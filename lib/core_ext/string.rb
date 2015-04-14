class String
  def class_from_string
    clazz = self.split('::').inject(Object) {|o,c| o.const_get c}
    clazz
  end
end
