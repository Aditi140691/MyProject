Feature: Create test case to login to application and perform action
Background:
  * def planLocators = read("classpath:ProEdgeUI/objects/planLocators.json")
  * call read("classpath:ProEdgeUI/FunctionalFeatures/CommonFeatures/misc.feature")
  * def userData = read("classpath:ProEdgeUI/objects/userDetails.json")
  * configure readTimeout = 120000
  * def login = read('classpath:ProEdgeUI/FunctionalFeatures/CommonFeatures/login.feature@testLogin')
 
@testCase1
Scenario Outline: Login to app, add prduct to cart and logout
  Given call login { platform : '#(testUrl)' }
  # Login to App with user credentials
  * def testUser = '<User>'
  * def password = userData.testPwd.password
  * waitR(planLocators.testLocators.username).click()
  * input(planLocators.testLocators.username,testUser)
  * waitR(planLocators.testLocators.password).click()
  * waitR(planLocators.testLocators.password).input(password)
  * waitR(planLocators.testLocators.btn_login).click()
  * if (exists(planLocators.testLocators.loginError)) karate.abort()
  # verify logo and product label on home page
  * waitR(planLocators.testLocators.logo_homepage)
  * waitR(planLocators.testLocators.productLabel)
  # Get all product names, prices on page and print it
  * def productNames = scriptAll(planLocators.testLocators.productName,'_.textContent')
  * def productPrices = scriptAll(planLocators.testLocators.productPrice,'_.textContent')
  * print productNames
  * print productPrices
  # Get the first product name, price and store it in text file
  * def firstProductName = text(planLocators.testLocators.productName)
  * print firstProductName
  * def firstProductPrice = text(planLocators.testLocators.productPrice)
  * print firstProductPrice
  # Append product name and price to CSV file
  * appendToCsv(firstProductName, firstProductPrice)
  # Add product to cart, verify product name and price on cart page
  * waitR(planLocators.testLocators.btn_addToCart).click()
  * waitR(planLocators.testLocators.btn_cart).click()
  * delay(2000)
  * def productName_cart = text(planLocators.testLocators.productName)
  * match productName_cart == firstProductName
  * def productPrice_cart = text(planLocators.testLocators.productPrice)
  * match productPrice_cart == firstProductPrice
  # Logout from app
  * waitR(planLocators.testLocators.hamburgerMenu).click()
  * waitR(planLocators.testLocators.btn_logout).click()
  * waitR(planLocators.testLocators.username)
   
  Examples:
  | User |
  | standard_user |
  | locked_out_user |
  | problem_user |
  | performance_glitch_user |
  | error_user |
  | visual_user |
 
 
@GetResponse
Scenario: Validate of GET response
  Given url apiUrl
  And method GET
  Then status 200
  And print response