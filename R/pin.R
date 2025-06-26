pin_if_board_exists <- function(
    board_connection,  # connection to board on server
    object_to_pin,  # will be meta or params_list
    pin_name  # pin path, like user.name/pin-name
) {

  is_board <- inherits(board_connection, c("pins_board_connect", "pins_board"))

  if (is_board) {

    object_class <- class(object_to_pin)
    if ("data.frame" %in% object_class) file_type <- "csv"
    if ("list" %in% object_class) file_type <- "rds"

    pins::pin_write(
      board_connection,
      x = object_to_pin,
      name = pin_name,
      type = file_type,
      versioned = TRUE
    )

  }

}
