module UserConstants
  SIGN_UP = '
    INSERT INTO users
    (username, email, password)
    VALUES($1, $2, $3)
    RETURNING id, username, email;'
  LOGIN = 'SELECT * FROM users WHERE username = $1 AND password = $2;'
end
