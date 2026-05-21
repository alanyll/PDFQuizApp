import XCTest
@testable import PDFQuizApp

final class QuestionDetectionTests: XCTestCase {

    let detector = QuestionDetector()

    // MARK: - Chinese Question Detection

    func testChineseSingleChoiceDetection() {
        let text = """
        1. 以下哪个选项是正确的？
        A. 选项一
        B. 选项二
        C. 选项三
        D. 选项四
        """

        let questions = detector.detectQuestions(from: text, pageNumber: 1)
        XCTAssertEqual(questions.count, 1)
        XCTAssertEqual(questions[0].type, .singleChoice)
        XCTAssertEqual(questions[0].options.count, 4)
        XCTAssertTrue(questions[0].confidence >= 0.5)
    }

    func testChineseNumberedWithDot() {
        let text = """
        一、下列选项中属于正确的是：
        A. 答案A
        B. 答案B
        C. 答案C
        D. 答案D
        """

        let questions = detector.detectQuestions(from: text, pageNumber: 1)
        XCTAssertEqual(questions.count, 1)
        XCTAssertEqual(questions[0].options.count, 4)
    }

    // MARK: - English Question Detection

    func testEnglishSingleChoiceDetection() {
        let text = """
        1. Which of the following is correct?
        A. First option
        B. Second option
        C. Third option
        D. Fourth option
        """

        let questions = detector.detectQuestions(from: text, pageNumber: 1)
        XCTAssertEqual(questions.count, 1)
        XCTAssertEqual(questions[0].type, .singleChoice)
        XCTAssertEqual(questions[0].options.count, 4)
    }

    func testEnglishQPrefixDetection() {
        let text = """
        Q1. What is the capital of France?
        A. London
        B. Paris
        C. Berlin
        D. Madrid
        """

        let questions = detector.detectQuestions(from: text, pageNumber: 1)
        XCTAssertTrue(questions.count >= 1)
    }

    // MARK: - Multiple Questions

    func testMultipleQuestionsInText() {
        let text = """
        1. 第一个问题是什么？
        A. 选项1
        B. 选项2
        C. 选项3

        2. 第二个问题是什么？
        A. 答案A
        B. 答案B
        C. 答案C
        D. 答案D
        """

        let questions = detector.detectQuestions(from: text, pageNumber: 1)
        XCTAssertEqual(questions.count, 2)
    }

    // MARK: - True/False Detection

    func testTrueFalseDetection() {
        let text = """
        1. 以下说法是否正确：地球是圆的。
        A. 正确
        B. 错误
        """

        let questions = detector.detectQuestions(from: text, pageNumber: 1)
        XCTAssertEqual(questions.count, 1)
        XCTAssertEqual(questions[0].type, .trueFalse)
    }

    // MARK: - Low Confidence Filtering

    func testLowConfidenceFilteredOut() {
        let text = """
        目录

        第一章 概述
        本章介绍了基本概念

        附录
        """

        let questions = detector.detectQuestions(from: text, pageNumber: 1)
        XCTAssertEqual(questions.count, 0)
    }
}
