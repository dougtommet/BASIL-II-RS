# The only long all-pairs object in Analysis2 is built here for graphics.
# A is the lower reviewer-column index, B the higher; signs depend on this order.
plot_paths <- character()
graphic_counts <- list()
for (stage in c("initial", "consensus")) {
  x <- matrices[[paste0("severity_", stage)]]
  pair_index <- combn(seq_len(ncol(x)), 2)
  display <- do.call(rbind, lapply(seq_len(ncol(pair_index)), function(j) {
    data.frame(A = x[, pair_index[1, j]], B = x[, pair_index[2, j]])
  }))
  display <- display[complete.cases(display), ]
  graphic_counts[[stage]] <- nrow(display)
  caption <- sprintf("%s: %d pooled comparisons from %d participants; descriptive", stage,
                     nrow(display), nrow(x))
  points <- dplyr::count(display, A, B, name = "comparisons")
  scatter <- ggplot2::ggplot(points, ggplot2::aes(A, B)) +
    ggplot2::geom_abline(intercept = 0, slope = 1, colour = "grey70") +
    ggplot2::geom_point(ggplot2::aes(size = comparisons), colour = "#234f70", alpha = .8) +
    ggplot2::scale_x_continuous(limits = c(0, 10), breaks = seq(0, 10, 2)) +
    ggplot2::scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, 2)) +
    ggplot2::coord_fixed() + ggplot2::theme_minimal(base_size = 11) +
    ggplot2::labs(x = "First reviewer within pair: severity", y = "Second reviewer within pair: severity",
                   subtitle = caption, size = "Comparisons")
  display$average <- (display$A + display$B) / 2
  display$difference <- display$A - display$B
  points <- dplyr::count(display, average, difference, name = "comparisons")
  ba <- ggplot2::ggplot(points, ggplot2::aes(average, difference)) +
    ggplot2::geom_hline(yintercept = c(-2, 0, 2), colour = "grey65", linetype = c(2, 1, 2)) +
    ggplot2::geom_point(ggplot2::aes(size = comparisons), colour = "#234f70", alpha = .8) +
    ggplot2::scale_x_continuous(limits = c(0, 10), breaks = seq(0, 10, 2)) +
    ggplot2::scale_y_continuous(limits = c(-10, 10), breaks = seq(-10, 10, 2)) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::labs(x = "Mean severity within reviewer pair", y = "Signed severity difference (first minus second)",
                   subtitle = caption, size = "Comparisons")
  for (type in c("scatter", "difference")) {
    plot <- if (type == "scatter") scatter else ba
    stem <- paste0("Analysis2_070-", if (type == "scatter") "01" else "02", "-", type, "-", stage)
    path <- here::here("FIGURES", paste0(stem, ".png"))
    ggplot2::ggsave(path, plot, device = ragg::agg_png, width = 6.5, height = 4.5, units = "in", dpi = 300)
    ggplot2::ggsave(here::here("FIGURES", paste0(stem, ".pdf")), plot,
                    device = grDevices::cairo_pdf, width = 6.5, height = 4.5, units = "in")
    plot_paths[paste(stage, type, sep = "_")] <- path
  }
  rm(display, points)
}
