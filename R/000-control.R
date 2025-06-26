
# Run the data management/log file
quarto::quarto_render(here::here("R", "_000-master.qmd"), output_format = "html")
fs::file_move(here::here("R", "_000-master.html"),
              here::here("Reports", stringr::str_c("BASIL RS_", Sys.Date(),".html")))

# Run the 2025-05-02 presentation
quarto::quarto_render(here::here("R", "ABC_presentation_2025-05-02.qmd"), output_format = "html")
fs::file_move(here::here("R", "ABC_presentation_2025-05-02.html"),
              here::here("Reports", stringr::str_c("ABC_presentation_2025-05-02_", Sys.Date(),".html")))

# Run the 2025-05-30 presentation
quarto::quarto_render(here::here("R", "ABC_presentation_2025-05-30.qmd"), output_format = "html")
fs::file_move(here::here("R", "ABC_presentation_2025-05-30.html"),
              here::here("Reports", stringr::str_c("ABC_presentation_2025-05-30_", Sys.Date(),".html")))
quarto::quarto_render(here::here("R", "ABC_presentation_2025-05-30.qmd"), output_format = "docx")
fs::file_move(here::here("R", "ABC_presentation_2025-05-30.docx"),
              here::here("Reports", stringr::str_c("ABC_presentation_2025-05-30_", Sys.Date(),".docx")))

# Run the 2025-06-06 presentation
quarto::quarto_render(here::here("R", "ABC_presentation_2025-06-06.qmd"), output_format = "html")
fs::file_move(here::here("R", "ABC_presentation_2025-06-06.html"),
              here::here("Reports", stringr::str_c("ABC_presentation_2025-06-06_", Sys.Date(),".html")))

# Run the 2025-06-27 presentation
quarto::quarto_render(here::here("R", "ABC_presentation_2025-06-27.qmd"), output_format = "html")
fs::file_move(here::here("R", "ABC_presentation_2025-06-27.html"),
              here::here("Reports", stringr::str_c("ABC_presentation_2025-06-27_", Sys.Date(),".html")))
