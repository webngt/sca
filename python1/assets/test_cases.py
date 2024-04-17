import unittest
from step0 import find_min  # Импортируем функцию из файла пользователя

# Тесты для задания 0
class TestAssignment0(unittest.TestCase):
    def test_find_min(self):
        self.assertEqual(find_min(1, 2), 1)
        self.assertEqual(find_min(2, 1), 1)
        self.assertEqual(find_min(-1, 1), -1)
        # Добавить больше тестовых случаев по необходимости

# Если у вас есть другие задания, добавьте классы для их тестов здесь

if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(TestAssignment0)
    result = unittest.TextTestRunner(verbosity=0).run(suite)
    if result.wasSuccessful():
        print(True)
    else:
        print(False)

#для запуска - python3 test_cases.py TestAssignment0