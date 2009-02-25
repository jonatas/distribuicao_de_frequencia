
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

    class String
      def com(tamanho)
        (self + " " * tamanho)[0,tamanho]
      end
    end

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
