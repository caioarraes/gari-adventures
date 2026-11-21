# Gera os nós de Pista, Inimigos, Ecopontos e Placas da fase 1 em jogo/main.tscn.
# Uso, na raiz do projeto: perl ferramentas/montar_fase1.pl jogo/main.tscn
use strict;
use warnings;
local $/;
my $arquivo = shift;
open(my $e, '<:raw', $arquivo) or die;
my $t = <$e>;
close($e);

# Remove todos os nós filhos de Pista, Inimigos, Ecopontos e Placas.
for my $pai ('Pista', 'Inimigos', 'Ecopontos', 'Placas') {
	$t =~ s/\[node name="[^"]*"[^\n]*parent="\Q$pai\E(?:\/[^"]*)?"[^\n]*\]\n(?:(?!\[)[^\n]*\n)*//g;
}

sub caixa {
	my ($nome, $x, $y, $w, $h, $mat) = @_;
	return "[node name=\"$nome\" type=\"CSGBox3D\" parent=\"Pista\"]\nposition = Vector3($x, $y, 0)\nuse_collision = true\nsize = Vector3($w, $h, 4)\nmaterial = SubResource(\"$mat\")\n\n";
}
sub chao { my ($nome, $ini, $fim) = @_; my $w = $fim - $ini; my $c = ($ini + $fim) / 2; return caixa($nome, $c, -1, $w, 2, "chao"); }
sub caixote { my ($nome, $ini, $fim, $h) = @_; my $w = $fim - $ini; my $c = ($ini + $fim) / 2; return caixa($nome, $c, $h / 2, $w, $h, "plataforma"); }
sub flutuante { my ($nome, $ini, $fim, $topo) = @_; my $w = $fim - $ini; my $c = ($ini + $fim) / 2; return caixa($nome, $c, $topo - 0.3, $w, 0.6, "plataforma"); }
sub eletrico {
	my ($nome, $ini, $fim) = @_; my $w = $fim - $ini; my $c = ($ini + $fim) / 2;
	my $s = "[node name=\"$nome\" parent=\"Pista\" instance=ExtResource(\"9_chao_eletrico\")]\nposition = Vector3($c, 0, 0)\n";
	$s .= "largura = $w\n" if $w != 8;
	return "$s\n";
}
sub instancia { my ($nome, $pai, $ext, $x, $y) = @_; return "[node name=\"$nome\" parent=\"$pai\" instance=ExtResource(\"$ext\")]\nposition = Vector3($x, $y, 0)\n\n"; }
sub placa {
	my ($nome, $x, $y, $texto) = @_;
	return "[node name=\"$nome\" type=\"Label3D\" parent=\"Placas\"]\nposition = Vector3($x, $y, -1.9)\npixel_size = 0.01\ntext = \"$texto\"\nfont_size = 40\noutline_size = 14\n\n";
}

my $pista = '';
$pista .= caixa("ParedeInicial", -5.5, 4, 1, 10, "parede");
$pista .= chao("Chao1", -5, 12);
$pista .= caixote("Caixa", 8, 10, 1.2);
$pista .= chao("Chao2", 15, 24);
$pista .= flutuante("Plataforma1", 26, 29, 1.5);
$pista .= flutuante("Plataforma2", 31, 34, 3.0);
$pista .= chao("Chao3", 36, 44);
$pista .= eletrico("ChaoEletricoPequeno", 44, 46.5);
$pista .= chao("Chao3b", 46.5, 106);
$pista .= caixote("Caixa2", 64, 65.5, 1.2);
$pista .= caixote("Caixa3", 76, 79, 1.2);
$pista .= caixote("Torre", 79, 83.5, 2.4);
$pista .= caixote("Caixa4", 90, 91.5, 1.2);
$pista .= flutuante("Plataforma3", 108, 111, 0);
$pista .= flutuante("Plataforma4", 113, 116, 0);
$pista .= chao("Chao5", 118, 144);
$pista .= "[node name=\"Cerca\" type=\"CSGBox3D\" parent=\"Pista\"]\nposition = Vector3(136, 4, 0)\ncollision_layer = 16\nuse_collision = true\nsize = Vector3(0.6, 8, 4)\nmaterial = SubResource(\"invisivel\")\n\n";
$pista .= "[node name=\"Sprite\" type=\"Sprite3D\" parent=\"Pista/Cerca\"]\npixel_size = 0.053\nalpha_cut = 1\ntexture_filter = 0\ntexture = ExtResource(\"19_cerca\")\n\n";
$pista .= eletrico("ChaoEletricoMedio", 144, 146.5);
$pista .= chao("Chao6", 146.5, 158);
$pista .= eletrico("ChaoEletrico", 158, 166);
$pista .= instancia("Gerador", "Pista", "10_gerador", 166.7, 0);
$pista .= "[node name=\"Portao\" type=\"CSGBox3D\" parent=\"Pista\"]\nposition = Vector3(167.8, 2, 0)\nuse_collision = true\nsize = Vector3(0.4, 4, 4)\nmaterial = SubResource(\"portao\")\nscript = ExtResource(\"11_portao\")\n\n";
$pista .= chao("Chao4", 166, 172);
$pista .= caixa("ParedeFinal", 172.5, 4, 1, 10, "parede");

my $inimigos = '';
my @notebooks = ([2.5], [5], [18.5], [20.4], [40], [51]);
my $i = 1;
for my $n (@notebooks) { $inimigos .= instancia("Notebook$i", "Inimigos", "3_notebook", $n->[0], 0); $i++; }
$inimigos .= instancia("Microondas1", "Inimigos", "5_microondas", 68.5, 0);
$inimigos .= instancia("Microondas2", "Inimigos", "5_microondas", 82.8, 2.4);
$inimigos .= instancia("Microondas3", "Inimigos", "5_microondas", 96, 0);
$inimigos .= instancia("Microondas4", "Inimigos", "5_microondas", 121, 0);
$inimigos .= instancia("Microondas5", "Inimigos", "5_microondas", 129, 0);
$inimigos .= instancia("MicroondasFinal", "Inimigos", "5_microondas", 140, 0);
$inimigos .= instancia("Fio1", "Inimigos", "7_fio", 141.6, 0);
$inimigos .= instancia("Fio2", "Inimigos", "7_fio", 150.5, 0);
$inimigos .= instancia("Fio3", "Inimigos", "7_fio", 154, 0);

my $ecopontos = '';
$i = 1;
for my $x (16, 36.8, 56, 89, 103, 137.5) { $ecopontos .= instancia("Ecoponto$i", "Ecopontos", "8_ecoponto", $x, 0); $i++; }

my $placas = '';
$placas .= placa("Placa1", 3, 3.4, "Células boas de notebook viram powerbank");
$placas .= placa("Placa7", 45.25, 3.4, "Chão eletrificado: pule por cima");
$placas .= placa("Placa2", 62, 3.8, "Motor de micro-ondas vira dínamo: pistola de faíscas");
$placas .= placa("Placa9", 64.75, 2.6, "As caixas bloqueiam as ondas");
$placas .= placa("Placa10", 77.5, 4.4, "Suba entre as ondas");
$placas .= placa("Placa8", 104, 3.6, "Derrube os micro-ondas de longe antes de pular");
$placas .= placa("Placa3", 133.5, 4.6, "Só faíscas atravessam a cerca");
$placas .= placa("Placa4", 143, 4, "Fios usados viram cobre: malha de aterramento");
$placas .= placa("Placa5", 162, 3.6, "Chão eletrificado: só passa quem está aterrado");
$placas .= placa("Placa6", 167, 4.6, "Gerador: traga a corrente do chão");

$t =~ s/(\[node name="Pista" type="Node3D" parent="\."\]\n\n)/$1$pista/ or die "pista";
$t =~ s/(\[node name="Inimigos" type="Node3D" parent="\."\]\n\n)/$1$inimigos/ or die "inimigos";
$t =~ s/(\[node name="Ecopontos" type="Node3D" parent="\."\]\n\n)/$1$ecopontos/ or die "ecopontos";
$t =~ s/(\[node name="Placas" type="Node3D" parent="\."\]\n\n)/$1$placas/ or die "placas";

$t =~ s/(\[node name="Chegada" type="Area3D" parent="\."\]\n)position = Vector3\([^)]*\)/${1}position = Vector3(168.5, 2, 0)/ or die "chegada";
$t =~ s/(\[node name="Gari" type="CharacterBody3D" parent="\."\]\nposition = [^\n]*\ncollision_layer = 2\n)/${1}collision_mask = 17\n/;

my $fundo = '';
my @predios = ([128, 4, -10, 9, 10, "predio_a"], [142, 5, -11, 10, 12, "predio_b"], [156, 3.5, -9, 9, 9, "predio_a"], [170, 5, -10, 10, 12, "predio_b"]);
$i = 10;
for my $p (@predios) {
	$fundo .= "[node name=\"Predio$i\" type=\"CSGBox3D\" parent=\"Fundo\"]\nposition = Vector3($p->[0], $p->[1], $p->[2])\nsize = Vector3($p->[3], $p->[4], 5)\nmaterial = SubResource(\"$p->[5]\")\n\n";
	$i++;
}
$t =~ s/(\[connection )/$fundo$1/ or die "fundo";

open(my $s, '>:raw', $arquivo) or die;
print $s $t;
close($s);
print "ok\n";
