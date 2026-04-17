library(usethis)

use_git_config(user.name = "a-nhmai",
                user.email  = "27maianh@gmail.com")

use_git()

create_github_token()

#connecting rstudio to github
library(gitcreds)

gitcreds_set()

#create repo
use_github()
