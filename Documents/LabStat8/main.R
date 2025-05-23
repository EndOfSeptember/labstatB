# Load libraries one liner
invisible(lapply(
  c("readxl", "dplyr", "ggplot2", "showtext", "scales"),
  library, character.only = TRUE))

# Load dataset
dataset <- read_excel("Laryngo.xlsx")

# Convert variables to factors
dataset <- dataset %>%
  mutate(
    attempt1_S_F = factor(
      attempt1_S_F,
      levels = c(0, 1),
      labels = c("Failure", "Success")
    ),
    Randomization = factor(
      Randomization,
      levels = c(0, 1),
      labels = c("Standard Macintosh #4", "AWS Pentax Video")
    ),
    gender = factor(
      gender,
      levels = c(0, 1),
      labels = c("Female", "Male")
    ),
  )

# Load cherry font (check dir)
font_add(family = "cherry", regular = "CherryHand-Regular.ttf")
showtext_auto()

# Sakura color palette + wrapper function
sakura_pal  <- c("#F7CAC9", "#F5E3E0")
sakura_line <- "#E8A2B7"
sakura_text <- "#8B5E83"
sakura_bg   <- "#FFF5F7"
sakura_grid <- "#FDE4EC"

theme_sakura <- function(base_size = 14, base_family = "cherry") {
  theme_minimal(base_size = base_size, base_family = base_family) %+replace%
    theme(
      plot.background   = element_rect(fill = sakura_bg,  colour = NA),
      panel.background  = element_rect(fill = sakura_bg,  colour = NA),
      panel.grid.major  = element_line(colour = sakura_grid, size = 0.25),
      panel.grid.minor  = element_blank(),
      axis.text         = element_text(colour = sakura_text),
      axis.title        = element_text(colour = sakura_text),
      plot.title        = element_text(colour = sakura_text, face = "bold",
                                       hjust = 0.5, size = base_size + 3),
      legend.background = element_rect(fill = sakura_bg, colour = NA),
      legend.key        = element_rect(fill = sakura_bg, colour = NA),
      legend.text       = element_text(colour = sakura_text),
      legend.title      = element_text(colour = sakura_text)
    )
}

# Graph 1: Faceted bar chart
ggplot(dataset, aes(x = attempt1_S_F, fill = Randomization)) +
  geom_bar(position = position_dodge(width = 0.8), width = 0.7, colour = sakura_line, size = 0.3) +
  facet_wrap(~ gender) +
  scale_fill_manual(values = sakura_pal) +
  labs(
    title = "Absolute Frequencies of Attempt by Randomization faceted by Gender",
    x = "Attempt Outcome",
    y = "Frequency",
    fill = "Randomization used"
  ) +
  theme_sakura()

# Graph 2: Density plot
ggplot(dataset, aes(x = age, fill = attempt1_S_F)) +
  geom_density(alpha = 0.6, colour = sakura_line, size = 0.3) +
  scale_fill_manual(values = sakura_pal) +
  labs(
    title = "Age Distribution by Attempt Outcome",
    x = "Age in years",
    y = "Relative Frequency",
    fill = "Attempt Result"
  ) +
  theme_sakura()

# Graph 3: Violin + boxplot with star outliers
ggplot(dataset, aes(x = attempt1_S_F, y = age, fill = attempt1_S_F)) +
  geom_violin(trim = FALSE, colour = sakura_line, size = 0.3, alpha = 0.7) +
  geom_boxplot(
    width         = 0.15,
    fill          = sakura_bg,
    colour        = sakura_text,
    size          = 0.4,
    outlier.shape = 8,
    outlier.color = sakura_line,
    outlier.fill  = sakura_pal[1],
    outlier.size  = 4,
    outlier.alpha = 1
  ) +
  geom_dotplot(binaxis='y', 
               stackdir='center', 
               dotsize = .8,
               fill=sakura_text) +
  scale_fill_manual(values = sakura_pal) +
  labs(
    title = "Age by Attempt Outcome",
    x = "Attempt Outcome",
    y = "Age (years)",
    fill = "Result"
  ) +
  theme_sakura()
