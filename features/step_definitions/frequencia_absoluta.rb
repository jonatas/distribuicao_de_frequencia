# interpretacao da amplitude da classe
# 60,2 + 2.5 = 61,
# ponto medio (xi)
# xi = (kg.inferior + kg.superior )/ 2
# tbl distribuicao de frequancia variabel continua
# pesos (kg)     |  fi | fr    |  f%  | fac | fad | xi
# 60.2 |-- 61.7  |  7  | 0.175 | 17.5 | 7   |  40 | 60.95 
# 61.7 |-- 63.2  |  5  | 0.125 | 12   | 3   |  33 | 62.45
#
#declaracao do relatorio 
#os pesos de 40 pessoas
#variam entre #{extremidades dos elementos}
# 17.5% tem peso medio de 60.95
# 17 pessoas tem peso inferior a 64,7 
# 
# tem peso medio entre
require 'rubygems'
require 'spec'
class Distribuicao
  attr_reader :elementos, :frequencia_absoluta, :frequencia_relativa, :frequencia_percentual
  
  def initialize(elementos)
    @elementos = elementos
    calcular_frequencia_absoluta
    calcular_frequencia_relativa
    calcular_frequencia_percentual
  end
  def numero_da_classe
    # raiz quadrada dos elementos
    Math.sqrt(elementos.length)
  end
  def soma_frequencia_absoluta
    @frequencia_absoluta.values.inject(0){|sum, e| sum += e ; sum}
  end

  # frequencia_absoluta = numero_de_vezes_do_elemento
  def calcular_frequencia_absoluta 
    @frequencia_absoluta = {}
    @elementos.group_by{|e| e}.each{|e,v| @frequencia_absoluta[e] = v.length}
    @frequencia_absoluta
  end

  # frequencia_relativa = frequencia_absoluta/sum(frequencia_absoluta)
  def calcular_frequencia_relativa
    @frequencia_relativa = {}
    @frequencia_absoluta.each{|elemento, frequencia_absoluta| @frequencia_relativa[elemento] = (frequencia_absoluta.to_f / soma_frequencia_absoluta.to_f)} 
  end

  def calcular_frequencia_percentual
    @frequencia_percentual = {}
    @frequencia_relativa.each{|elemento, fr| @frequencia_percentual[elemento] = (fr * 100)} 
  end
  def to_s
    "soma_frequencia_absoluta: #{soma_frequencia_absoluta}\n"+
    "numero_da_classe: #{numero_da_classe}\n"+
    " elemento | frequencia absoluta | frequencia relativa | frequencia percentual \n"+
    @elementos.uniq.collect do |elemento|
      "  #{elemento.to_s.com(7)} | #{@frequencia_absoluta[elemento].to_s.com(19)} | #{@frequencia_relativa[elemento].to_s.com(19)} | #{@frequencia_percentual[elemento].to_s.com(20)}"
    end.join("\n")
  end
  def amplitude_total
    ordenado = elementos.uniq.sort
    ordenado.last.to_f - ordenado.first.to_f
  end
end
class String
  def com(tamanho)
    (self + " " * tamanho)[0,tamanho]
  end
end

Given /^as idades (.*)$/ do |numeros|
   @idades ||= []
   @idades += numeros.split(" ")
end

Then /^quando calcular a frequencia (.*)$/ do |qual|
  @distribuicao = Distribuicao.new @idades
  @frequencia = @distribuicao.send("frequencia_#{qual.tr(" ","_")}")
end

Then /^deve existir uma idade (.*) com (.*)$/ do |idade, frequencia|
  @frequencia[idade].should be == frequencia.to_f
end
Then /^a soma dos fis deve ser (.*)$/ do |soma_fi|
  @distribuicao.soma_frequencia_absoluta.should be == soma_fi.to_f
end

Then  /^[oa] (.*) deve ser igual a (.*)$/ do |metodo,valor|
  @distribuicao.send(metodo.gsub(/ /,"_")).to_s.should be == valor
end

After do
  puts @distribuicao
  puts Distribuicao.new([60.2, 60.4, 60.8, 61.3, 61.3, 61.3,
                   61.4, 61.7, 61.7, 62.3, 62.3, 62.6,
                   63.2, 63.8, 64.2, 64.5, 64.6, 64.9,
                   65.2,  65.3, 65.3, 65.4 , 66.0, 66.1,
                   66.2, 66.4, 66.4, 66.9, 67.0, 67.3,
                   67.3, 68.2, 68.3, 69.3, 69.5,
                   69.7, 69.8, 70.0, 70.0])
end
