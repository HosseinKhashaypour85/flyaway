class AppUrlsConfig {
  static const baseUrl = 'https://flyaway.codeplusdev.ir/api';
  static const createUser = '$baseUrl/users/create';
  static const checkIp = '$baseUrl/user/checkIp';
  static const sendOtp = '$baseUrl/auth/send-otp';
  static const confirmOtp = '$baseUrl/auth/confirm-otp';
  static const buyTicket = '$baseUrl/tickets/buyTicket';
  static const findTicketByEmail = '$baseUrl/tickets';
  static const cancelTicket = '$baseUrl/tickets/cancell_ticket';
  static const getWalletCount = '$baseUrl/users/wallet/find_wallet';
  static const addAmountToWallet = '$baseUrl/users/wallet/add_amount';
  static const decreaseAmountOfWallet = '$baseUrl/users/wallet/decrease_amount';
  static const homeRowsTicket = 'https://hosseinkhashaypour.chbk.app/api/collections/rowTickets/records';
  static const allComments = '$baseUrl/comments';
  static const createComment = '$baseUrl/comments/add';
  static const getAllTrips = '$baseUrl/tickets';
  static const payment = '$baseUrl/pay';
  static const farazApiKeyToken = 'YTA3ZDg5MWUtNGIxNS00NTNmLWJjZTUtZjljMWIwYjA1NDkyOThmMjIwMWNjOTI5NmEzOGViOTdmOGJjYzRjNjgxNzc=';
}