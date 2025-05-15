pin_if_board_exists <- function(board_connection, tagged_runs_meta, pin_name) {

  is_board <- inherits(board_connection, c("pins_board_connect", "pins_board"))

  if (is_board) {

    pin_exists <- pins::pin_exists(pin_name)

      pins::pin_write(
        board_connection,
        x = tagged_runs_meta,
        name = pin_name,
        type = "csv",
        versioned = TRUE
      )

    }

}
