#' Write an Object to a Pins Board
#' @param board_connection A pins board object, typically created with
#'   `pins::board_connect()`.
#' @param object_to_pin The object to write to the board. Must be either a
#'   data frame (written to CSV) or a list (written to RDS).
#' @param pin_name A character string giving the pin path (e.g.
#'   `"user.name/pin-name"`).
#' @return Invisibly returns the result of `pins::pin_write()` when the board
#'   exists, otherwise invisibly returns `NULL`.
pin_if_board_exists <- function(
  board_connection,
  object_to_pin,
  pin_name
) {
  is_board <- inherits(board_connection, c("pins_board_connect", "pins_board"))

  if (is_board) {
    object_class <- class(object_to_pin)
    file_type <- "rds"
    if ("data.frame" %in% object_class) {
      file_type <- "csv"
    }

    pins::pin_write(
      board_connection,
      x = object_to_pin,
      name = pin_name,
      type = file_type,
      versioned = TRUE
    )
  }
}
