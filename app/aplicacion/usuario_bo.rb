class UsuarioBO
  def do_login(login, password)
    Usuario.where(login:login,password:password).first()
  end
end