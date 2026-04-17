#260417 Bayes Tutorial
#https://www.r-bloggers.com/2026/03/bayesian-linear-regression-in-r-a-step-by-step-tutorial/.


## Loading Packages
install.packages(c(
  "brms",
  "tidyverse",
  "tidybayes",
  "bayesplot",
  "posterior",
  "loo",
  "rstanarm"
))

packages_ls <- c(
  "brms",
  "tidyverse",
  "tidybayes",
  "bayesplot",
  "posterior",
  "loo",
  "rstanarm"
)

sapply(packages_ls, require, character.only = TRUE)







##simple dataset simulation
set.seed(123)

n <- 120 #number of observations

advertising_spend <- rnorm(n, mean = 15, sd = 4)

sales <- 20 + 3.5 * advertising_spend + rnorm(n, mean = 0, sd = 8)

df <- data.frame(
  advertising_spend = advertising_spend,
  sales = sales
)






##visual inspection
summary(df)
glimpse(df)





##classical baseline using lm() function
lm_model <- lm(sales ~ advertising_spend, df)
summary(lm_model)

  #intercept = 25.3066
  #slope = 3.1901





##Bayes analysis
###choosing priors
priors <- c(
  prior(normal(0, 20), class = "Intercept"),
  prior(normal(0, 10), class = "b"),
  prior(student_t(3, 0, 10), class = "sigma")
)


###fititng Bayes LRM
bayes_model <- brm(
  formula = sales ~ advertising_spend,
  data = df,
  prior = priors,
  family = gaussian(),
  chains = 4,
  iter = 4000,
  warmup = 2000,
  seed = 123
)

summary(bayes_model)

###extracting posterior draws
draws <- as_draws_df(bayes_model)
head(draws)

mean(draws$b_advertising_spend > 0)

###visualizingn posterior distributions
plot(bayes_model)

mcmc_areas(
  as.array(bayes_model),
  pars = c("b_Intercept", "b_advertising_spend", "sigma")
)


###checking convergence with trace plots
mcmc_trace(
  as.array(bayes_model),
  pars = c("b_Intercept", "b_advertising_spend", "sigma")
)


###posterior predictive checks
pp_check(bayes_model)

  ####other checks
  pp_check(bayes_model, type = "dens_overlay")
  pp_check(bayes_model, type = "hist")
  pp_check(bayes_model, type = "scatter_avg")
  
  
  
###tidybayes for tidy posterior workflows -- I DONT UNDERSTAND THIS***
tidy_draws <- bayes_model %>%
  spread_draws(b_Intercept, b_advertising_spend, sigma)

head(tidy_draws)

tidy_draws %>%
  ggplot(aes(x = b_advertising_spend)) +
  geom_density(fill = "steelblue", alpha = 0.4) +
  theme_minimal()
  





##generating predictions for new data
new_customers <- data.frame(advertising_spend = c(10, 15, 20, 25)
                            )

predict(bayes_model, new_data = new_customers) #includes outcome uncertainty

fitted(bayes_model, newdata = new_customers) #focuses on expected mean response


###visualizing uncertainty
conditional_effects(bayes_model) #fitted relationship vs credible intervals



#alternative: rstanarm
rstanarm_model <- stan_glm(
  sales ~ advertising_spend,
  data = df,
  family = gaussian(),
  chains = 4,
  iter = 4000,
  seed = 123
)

print(rstanarm_model)

loo_result <- loo(bayes_model)
print(loo_result)

