class Api {
  // static const baseUrl = "http://192.168.1.119:7000";
  static const baseUrl = "http://192.168.1.74:7000";
  static const userRegister = "$baseUrl/api/v1/auth/register";
  static const userLogin = "$baseUrl/api/v1/auth/login";
  static const resetPassword = "$baseUrl/api/v1/auth";
  static const getUserDetails = "$baseUrl/api/v1/user";
  static const userDetailUpdate = "$baseUrl/api/v1/user";
  static const changePassword = "$baseUrl/api/v1/auth";

  //**products */
  static const getAllProdcts = "$baseUrl/api/v1/markets";
  static const createProducts = "$baseUrl/api/v1/user";
  static const getProductsByUid = "$baseUrl/api/v1/user";
  static const productUpdate = "$baseUrl/api/v1/market";
}
