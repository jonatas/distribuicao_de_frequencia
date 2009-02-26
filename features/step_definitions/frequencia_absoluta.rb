require 'rubygems'
require 'spec'
require File.dirname(__FILE__) + '/../../lib/frequencia_absoluta.rb'


Given /^as idades (.*)$/ do |numeros|
   @idades ||= []
   @idades += numeros.split(" ")
end

When /^calcular a frequencia (.*)$/ do |qual|
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

Then /^deve existir uma faixa de (\d+) a (\d+) com (\d+)$/ do |inicia, termina, resultado_esperado|
  @distribuicao.frequencia_absoluta[inicia..termina].should be == resultado_esperado.to_i
end
