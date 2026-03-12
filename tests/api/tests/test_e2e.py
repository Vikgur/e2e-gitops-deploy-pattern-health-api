import time
import pytest
import allure
import requests
from requests.auth import HTTPBasicAuth


@allure.step("GET-запрос к endpoint: {endpoint}")
def get_with_auth(api_base, endpoint):
    return requests.get(f"{api_base}{endpoint}", auth=HTTPBasicAuth("admin", "admin"))


@pytest.mark.parametrize("endpoint", ["/", "/health", "/version"])
def test_basic_endpoints_200(api_base, endpoint):
    allure.dynamic.title(f"Проверка доступности {endpoint}")
    allure.dynamic.description(
        "Проверяем, что endpoint возвращает 200 и корректный Content-Type"
    )

    with allure.step("Отправка GET-запроса"):
        res = get_with_auth(api_base, endpoint)

    with allure.step("Проверка кода ответа"):
        assert res.status_code == 200

    with allure.step("Проверка Content-Type"):
        assert res.headers["Content-Type"].startswith("application/json")


def test_db_test_growth(api_base):
    allure.dynamic.title("Проверка роста количества записей в /db-test")
    allure.dynamic.description(
        "Сравниваем количество записей до и после повторного запроса"
    )

    with allure.step("Первый запрос к /db-test"):
        res1 = get_with_auth(api_base, "/db-test")
        assert res1.status_code == 200
        count1 = len(res1.json())

    with allure.step("Повторный запрос к /db-test"):
        res2 = get_with_auth(api_base, "/db-test")
        assert res2.status_code == 200
        count2 = len(res2.json())

    with allure.step("Сравнение количества записей"):
        assert count2 >= count1


def test_db_test_last_5(api_base):
    allure.dynamic.title(
        "Проверка, что /db-test возвращает не более 5 последних записей"
    )
    allure.dynamic.description("Проверяем структуру и количество записей")

    with allure.step("Запрос к /db-test"):
        res = get_with_auth(api_base, "/db-test")
        assert res.status_code == 200
        data = res.json()

    with allure.step("Проверка, что результат — список из не более 5 записей"):
        assert isinstance(data, list)
        assert len(data) <= 5

    with allure.step("Проверка структуры каждой записи"):
        for entry in data:
            assert "id" in entry
            assert "message" in entry
            assert "timestamp" in entry


def test_db_test_fail(api_base):
    allure.dynamic.title("Проверка фейла при неправильном hostname")
    allure.dynamic.description("Меняем localhost на неизвестный хост и ожидаем ошибку")

    wrong_url = api_base.replace("localhost", "unknown-host")

    with allure.step("Пробуем запрос к недоступному адресу"):
        try:
            res = requests.get(
                f"{wrong_url}/db-test", timeout=3, auth=HTTPBasicAuth("admin", "admin")
            )
        except requests.exceptions.RequestException:
            with allure.step("Получено исключение — как и ожидалось"):
                assert True
        else:
            with allure.step("Ответ получен — должен быть 500 или ошибка"):
                assert res.status_code == 500


def test_send_kafka(api_base):
    allure.dynamic.title("Проверка /send-kafka")
    allure.dynamic.description("Проверяем успешную отправку сообщения в Kafka")

    with allure.step("Отправка запроса на /send-kafka"):
        for attempt in range(5):
            res = get_with_auth(api_base, "/send-kafka")
            if res.status_code == 200:
                break
            time.sleep(1)
        assert res.status_code == 200, f"Expected 200 OK, got {res.status_code}"
        data = res.json()

    with allure.step("Проверка структуры ответа"):
        assert "status" in data
        assert "message" in data
        assert "service" in data["message"]
        assert "timestamp" in data["message"]
