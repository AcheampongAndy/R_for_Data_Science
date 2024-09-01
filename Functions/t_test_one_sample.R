# t-value for one sample t-test
t_value <- function(mu, vec){
  vec_len = 0
  tot_num = 0
  tot_var_set = 0
  var_set = c()
  for (num in vec) {
    if (num){
      vec_len = vec_len + 1
      tot_num = tot_num + num
    }
  }
  vec_mean = tot_num / vec_len
  numerator = vec_mean - mu
  
  len = 0
  for (num in vec){
    if (num){
      len = len + 1
    }
    var = num - vec_mean
    var_set[len] = var^2
  }
  
  for (num in var_set){
    tot_var_set = tot_var_set + num
  }
  
  vr = tot_var_set / (vec_len - 1)
  se = vr^(1/2)
  
  denominator = se / vec_len^(1/2)
  
  result = numerator / denominator
  return(result)
}
