import unittest
from src.data.preprocess.py import preprocess_data

class TestPreprocessData(unittest.TestCase):
    def test_preprocess_data(self):
        raw_data = ...
        processed_data = preprocess_data(raw_data)
        self.assertIsNotNone(processed_data)

if __name__ == '__main__':
    unittest.main()
