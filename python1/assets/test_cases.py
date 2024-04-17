import unittest
from pprint import pprint
from step0 import find_min  # Импортируем функцию из файла пользователя
import os

# Тесты для задания 0
class TestAssignment0(unittest.TestCase):
    def test_find_min(self):
        self.assertEqual(find_min(1, 2), 1)
        self.assertEqual(find_min(2, 1), 1)
        self.assertEqual(find_min(-1, 1), -1)
        # Добавить больше тестовых случаев по необходимости

# Если у вас есть другие задания, добавьте классы для их тестов здесь

OK = 'ok'
FAIL = 'fail'
ERROR = 'error'
SKIP = 'skip'

class JsonTestResult(unittest.TextTestResult):

    def __init__(self, stream, descriptions, verbosity):
        super_class = super(JsonTestResult, self)
        super_class.__init__(stream, descriptions, verbosity)

        # TextTestResult has no successes attr
        self.successes = []

    def addSuccess(self, test):
        # addSuccess do nothing, so we need to overwrite it.
        super(JsonTestResult, self).addSuccess(test)
        self.successes.append(test)

    def json_append(self, test, result, out):
        suite = test.__class__.__name__
        if suite not in out:
            out[suite] = {OK: [], FAIL: [], ERROR:[], SKIP: []}
        if result is OK:
            out[suite][OK].append(test)
        elif result is FAIL:
            out[suite][FAIL].append(test)
        elif result is ERROR:
            out[suite][ERROR].append(test)
        elif result is SKIP:
            out[suite][SKIP].append(test)
        else:
            raise KeyError("No such result: {}".format(result))
        return out

    def jsonify(self):
        json_out = dict()
        for t in self.successes:
            json_out = self.json_append(t, OK, json_out)

        for t, _ in self.failures:
            json_out = self.json_append(t, FAIL, json_out)

        for t, _ in self.errors:
            json_out = self.json_append(t, ERROR, json_out)

        for t, _ in self.skipped:
            json_out = self.json_append(t, SKIP, json_out)

        return json_out




if __name__ == '__main__':
    # redirector default output of unittest to /dev/null
    with open(os.devnull, 'w') as null_stream:
        # new a runner and overwrite resultclass of runner
        runner = unittest.TextTestRunner(stream=null_stream)
        runner.resultclass = JsonTestResult

        # create a testsuite
        suite = unittest.TestLoader().loadTestsFromTestCase(TestAssignment0)

        # run the testsuite
        result = runner.run(suite)

        # print json output
        pprint(result.jsonify())


# if __name__ == '__main__':
#     suite = unittest.TestLoader().loadTestsFromTestCase(TestAssignment0)
#     result = unittest.TextTestRunner(verbosity=0).run(suite)
#     if result.wasSuccessful():
#         print(True)
#     else:
#         print(False)

#для запуска - python3 test_cases.py TestAssignment0