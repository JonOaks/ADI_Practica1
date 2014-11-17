class ValidacionError < StandardError
   def initialize(errores)
     @errores = errores
   end

   def errores
     @errores
   end
end