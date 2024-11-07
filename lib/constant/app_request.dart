// ignore_for_file: constant_identifier_names

class AppUrls {
  static const BASE_URL =
      "https://rd-cera-api-e0ekhjatfrgpfybj.centralindia-01.azurewebsites.net/api/";
  static const PINCODE_URL = "https://api.postalpincode.in/pincode/";
}

class MethodNames {
  // Master APIS
  static const getAllLocation = "Master/GetAllLocation";
  static const getAllBrand = "Master/GetAllBrand";
  static const getAllPunch = "Master/GetAllPunch";
  static const addBrand = "Master/AddBrand";
  static const addLocation = "Master/AddLocation";
  static const getModel = "Master/GetModel";
  static const addParentCategory = "Master/AddParentCategory";
  static const addCategory = "Master/AddCategory";
  static const addSubCategory = "Master/AddSubCategory";
  static const addCompanyDetail = "Master/AddCompanyDetail";
  static const getCompanyAndLogo = "Master/GetCompanyAndLogo";

  // Product APIS
  static const getParentCategoryByLocation =
      "Master/GetParentCategoryByLocation?locationId=";
  static const getCategoryByParentCategory =
      "Master/GetCategoryByParentCategory?parentCategoryId=";
  static const getSubCategoryByCategory =
      "Master/GetSubCategoryByCategory?categoryId=";
  static const getAllProductByCategoryId =
      "Product/GetAllProductByCategoryId?categoryId=";
  static const getProductById = "Product/GetProductbyId?productId=";
  static const uploadProductImage = "Product/UploadImages";
  static const addProduct = "Product";
  static const updateProduct = "Product/";
  static const getProductBySubCategoryId =
      "Product/GetProductBySubCategoryId?subCategoryId=";
  static const deleteProduct = "Product/";
  static const updatePurchaseBoxCount = "Product/UpdatePurchaseBoxCount?";
  static const updateSalesBoxCount = "Product/UpdateSalesBoxCount?";
  static const updateOnTheWayBox = "Product/UpdateOnTheWayBox?";
  static const getAllProduct = "Product/GetAllProduct";

  // Auth APIS
  static const authLogin = "Auth/Login";

  // User APIS
  static const createUser = "User/CreateUser";
  static const createOrder = "User/CreateOrder";
  static const getMyOrders = "User/GetMyOrder?loggedInUserId=";
  static const getCustomerOrders = "User/GetCustomerOrder?daysCount=";
  static const getUserProfile = "User/GetUserProfile?loggedInUserId=";
  static const approveOrder = "User/OrderApprovedByAdmin";
  static const addFCMToken = "User/AddFCMToken";
  static const updateFCMToken = "User/UpdateFCMTokem?";
  static const getAllFCMToken = "User/GetAllFCMToken";
}
