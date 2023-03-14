class ApiEndPoints {
//Group
  static String getgroup = '/api/createGroup/get';
  static String createGroup = '/api/createGroup/create';
  static String joinGroup = '/api/createGroup/join';
  static String message = '/api/createGroup/message';
  static String editGroupImage = '/api/createGroup/editImage';
  static String editGroupName = '/api/createGroup/editGroupName';
  static String openGroup = '/api/createGroup/open';

//profile
  static String signUp = '/api/profile/addNew';
  static String showProfile = '/api/profile/showProfile';
  static String getImage = '/api/profile/image?q=';
  static String editProfileImage = '/api/profile/editImage';

//UserPost
  static String getPosts = '/api/userPosts';
  static String addPost = '/api/userPosts/post';
  static String regUserPost = '/api/userPosts/join';

//Wishlist
  static String addToWishlist = '/api/userPosts/wishList';
  static String removeFromWishlist = '/api/userPosts/removeSaved'; 
}
