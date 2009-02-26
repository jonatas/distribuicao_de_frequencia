module SomaItensDoHashQuandoIntervalo
  def [] elemento 
    if elemento.respond_to? :include?
      self.inject(0){|sum, e| sum += e.last if elemento.include?(e.first) ; sum}
    else
      self[elemento]
    end
  end
end

# numero de vezes do elemento 
# se passar um intervalo entao vai dizer a quantia de vezes
## Distribuicao.new([1,2,2,2,1,5]).frequencia_absoluta[2] => 3
## Distribuicao.new([1,2,2,2,1,5]).frequencia_absoluta[1..2] => 5
class Distribuicao
  attr_reader :elementos, :frequencia_relativa, :frequencia_percentual, :frequencia_absoluta
  
  def initialize(elementos)
    @elementos = elementos
    calcular_frequencia_absoluta
    calcular_frequencia_relativa
    calcular_frequencia_percentual
    @frequencia_absoluta.extend SomaItensDoHashQuandoIntervalo
  end
  def numero_da_classe
    # raiz quadrada dos elementos
    Math.sqrt(elementos.length)
  end

  # frequencia_absoluta = numero_de_vezes_do_elemento
  # Frequências relativas (fri) são os valores das razões entre as frequências simples e a frequência total:
  # ∑ fi = n
  def calcular_frequencia_absoluta 
    @frequencia_absoluta = {}
    @elementos.group_by{|e| e}.each{|e,v| @frequencia_absoluta[e] = v.length}
    @frequencia_absoluta
  end

  # frequencia_relativa = frequencia_absoluta/sum(frequencia_absoluta)
  # Freqüências relativas (fri) são os valores das razões entre as freqüências simples e a freqüência total:
  # fri = fi /∑ fi
  def calcular_frequencia_relativa
    @frequencia_relativa = {}
    @frequencia_absoluta.each{|elemento, frequencia_absoluta| @frequencia_relativa[elemento] = (frequencia_absoluta.to_f / soma_frequencia_absoluta.to_f)} 
  end

  # Percentual baseado na frequencia relativa 
  def calcular_frequencia_percentual
    @frequencia_percentual = {}
    @frequencia_relativa.each{|elemento, fr| @frequencia_percentual[elemento] = (fr * 100)} 
    @frequencia_percentual
  end

  #Freqüência acumulada (Fi) é o total das freqüências de todos os valores inferiores ao limite superior do intervalo de uma dada classe:
  #Fk = f1 + f2 + ... + fk   ou   Fk = ∑ fi (i = 1, 2, ..., k)
  def frequencia_acumulada(intervalo)
    frequencia_absoluta[primeiro_elemento..intervalo.last]
  end

  def to_s

    "soma_frequencia_absoluta: #{soma_frequencia_absoluta}\n"+
    "numero_da_classe: #{numero_da_classe}\n"+
    " elemento | frequencia absoluta | frequencia relativa | frequencia percentual \n"+
    @elementos.uniq.collect do |elemento|
      "  #{elemento.to_s.com(7)} | #{@frequencia_absoluta[elemento].to_s.com(19)} | #{@frequencia_relativa[elemento].to_s.com(19)} | #{@frequencia_percentual[elemento].to_s.com(20)}"
    end.join("\n")
  end


  def soma_frequencia_absoluta
    @frequencia_absoluta.values.inject(0){|sum, e| sum += e ; sum}
  end

  def elementos_ordenado
    elementos.uniq.sort
  end

  def amplitude_total
    ultimo_elemento.to_f - primeiro_elemento.to_f
  end

  def primeiro_elemento 
    elementos_ordenado.first
  end

  def ultimo_elemento 
    elementos_ordenado.last
  end
end

class String
  def com(tamanho)
    (self + " " * tamanho)[0,tamanho]
  end
end
