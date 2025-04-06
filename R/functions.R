# Weather Analysis Functions

save_visualisations <- function(plots, base_dir = "outputs", prefix = "", width = 10, height = 8, dpi = 300) {
  dir.create(here::here(base_dir), showWarnings = FALSE)
  if (!is.list(plots)) {
    plots <- list(plots)
  }
  for (plot_name in names(plots)) {
    filename <- file.path(base_dir, paste0(prefix, "_", plot_name, ".png"))
    w <- if (!is.null(attr(plots[[plot_name]], "width"))) attr(plots[[plot_name]], "width") else width
    h <- if (!is.null(attr(plots[[plot_name]], "height"))) attr(plots[[plot_name]], "height") else height
    d <- if (!is.null(attr(plots[[plot_name]], "dpi"))) attr(plots[[plot_name]], "dpi") else dpi
    
    png(filename = here::here(filename), width = w, height = h, units = "in", res = d)
    
    tryCatch({
      if (inherits(plots[[plot_name]], "ggplot")) {
        print(plots[[plot_name]])
      } else if (inherits(plots[[plot_name]], "gtable") || 
                inherits(plots[[plot_name]], "grob") ||
                inherits(plots[[plot_name]], "arrangelist")) {
        grid::grid.draw(plots[[plot_name]])
      } else if (inherits(plots[[plot_name]], "brmsfit")) {
        # Handle brms model objects
        plot(plots[[plot_name]])
      } else if (inherits(plots[[plot_name]], "bayesplot")) {
        # Handle bayesplot objects (posterior plots)
        print(plots[[plot_name]])
      } else if (inherits(plots[[plot_name]], "mcmc.list") || 
                inherits(plots[[plot_name]], "mcmc")) {
        # Handle MCMC objects
        plot(plots[[plot_name]])
      } else {
        print(plots[[plot_name]])
      }
    }, error = function(e) {
      warning(sprintf("Failed to save plot %s: %s", plot_name, e$message))
    }, finally = {
      dev.off()
    })
  }
  cat("All visualisations have been saved to the", base_dir, "directory\n")
}

interpret_correlation <- function(r, variable_name) {
  r_squared <- r^2
  var_explained <- r_squared * 100
  strength <- if(abs(r) >= 0.7) "strong" else if(abs(r) >= 0.5) "moderate" else "weak"
  direction <- if(r > 0) "positive" else "negative"
  
  cat(sprintf("\nCorrelation Analysis: %s vs Temperature", variable_name))
  cat(sprintf("\n- r = %.3f, R² = %.3f", r, r_squared))
  cat(sprintf("\n- %s %s correlation", strength, direction))
  cat(sprintf("\n- %.1f%% of temperature variance explained", var_explained))
  cat(sprintf("\n- As %s increases, temperature tends to %s\n", 
              tolower(variable_name), 
              if(r > 0) "increase" else "decrease"))
}

state_summary <- function(state_code) {
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("dplyr package is required for this function")
  }
  
  state_data <- dplyr::filter(weather, State == state_code)
  
  if (nrow(state_data) == 0) {
    return(list(
      state = state_code,
      message = "No data available for this state",
      num_cities = 0,
      avg_temp = NA
    ))
  }
  
  num_cities <- nrow(state_data)
  avg_temp <- mean(state_data$avg_temp)
  
  return(list(
    state = state_code,
    num_cities = num_cities,
    avg_temp = avg_temp
  ))
}

f_test_data_dredger <- function(model_summary, alpha) {
  # Calculate p-value from F-statistic
  p_value <- pf(model_summary$fstatistic[1], 
                model_summary$fstatistic[2], 
                model_summary$fstatistic[3], 
                lower.tail = FALSE)
  if (p_value < alpha) {
    result <- paste("The overall model is statistically significant at the", alpha, "level.")
    result <- paste(result, "We reject the null hypothesis that all coefficients equal zero.")
  } else {
    result <- paste("The overall model is not statistically significant at the", alpha, "level.")
    result <- paste(result, "We fail to reject the null hypothesis that all coefficients equal zero.")
  }
  return(result)
} 

model_info <- function(model, name) {
  data.frame(
    Model = name,
    Variables = paste(names(coef(model))[-1], collapse = ", "), # Exclude intercept
    R_squared = summary(model)$r.squared,
    Adj_R_squared = summary(model)$adj.r.squared,
    AIC = AIC(model),
    BIC = BIC(model)
  )
} 

cv_rmse <- function(model, data, k = 5) {
  set.seed(123)  # For reproducibility
  folds <- cut(seq(1, nrow(data)), breaks = k, labels = FALSE)
  cv_errors <- numeric(k)
  for (i in 1:k) {
    test_indices <- which(folds == i)
    train_data <- data[-test_indices, ]
    test_data <- data[test_indices, ]
    model_formula <- formula(model)
    train_model <- lm(model_formula, data = train_data)
    predictions <- predict(train_model, newdata = test_data)
    cv_errors[i] <- sqrt(mean((test_data$avg_temp - predictions)^2))
  }
  return(mean(cv_errors))
} 

calculate_diagnostics <- function(model, model_name) {
  model_summary <- summary(model)
  sw_test <- shapiro.test(residuals(model))
  bp_test <- bptest(model)
  rmse <- sqrt(mean(residuals(model)^2))
  mae <- mean(abs(residuals(model)))
  data.frame(
    Model = model_name,
    Adj_R_squared = model_summary$adj.r.squared,
    RSE = model_summary$sigma,
    AIC = AIC(model),
    Shapiro_W = sw_test$statistic,
    Shapiro_p = sw_test$p.value,
    BP_stat = bp_test$statistic,
    BP_p = bp_test$p.value,
    RMSE = rmse,
    MAE = mae
  )
}