class AppUrlsConfig {
  static const baseUrl = 'https://flyaway.codeplusdev.ir/api';
  static const createUser = '$baseUrl/users/create';
  static const checkIp = '$baseUrl/user/checkIp';
  static const buyTicket = '$baseUrl/tickets/buyTicket';
  static const findTicketByEmail = '$baseUrl/tickets';
  static const cancelTicket = '$baseUrl/tickets/cancell_ticket';
  static const addAmountToWallet = '$baseUrl/users/wallet/add_amount';
  static const decreaseAmountOfWallet = '$baseUrl/users/wallet/decrease_amount';
  static const homeRowsTicket = 'https://hosseinkhashaypour.chbk.app/api/collections/rowTickets/records';
  static const allComments = '$baseUrl/comments';
  static const createComment = '$baseUrl/comments/add';
  static const getAllTrips = '$baseUrl/tickets';
  static const payment = '$baseUrl/pay';
}