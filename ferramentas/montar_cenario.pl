# Gera os nós de Fundo (rua, prédios, objetos de rua, morro e horizonte) em jogo/main.tscn.
# Uso, na raiz do projeto: perl ferramentas/montar_cenario.pl jogo/main.tscn
use strict;
use warnings;
use utf8;
use open qw(:std :utf8);
local $/;
my $arquivo = shift;
open(my $e, '<:encoding(UTF-8)', $arquivo) or die;
my $t = <$e>;
close($e);
srand(5);

my @texturas = qw(calcada concreto rua loja_a loja_b loja_c andar_a andar_b andar_c tapume ferro_velho toldo banca orelhao cone sucata bobina bag fiacao arvore morro saco lixeira poste);
my %id;
my $n = 60;
for my $nome (@texturas) {
	if ($t =~ /\[ext_resource type="Texture2D" path="res:\/\/arte\/\Q$nome\E\.png" id="([^"]+)"\]/) {
		$id{$nome} = $1;
		next;
	}
	$id{$nome} = $n . "_" . $nome;
	$n++;
	$t =~ s/(\[ext_resource [^\n]*\]\n)(?!\[ext_resource)/$1\[ext_resource type="Texture2D" path="res:\/\/arte\/$nome.png" id="$id{$nome}"\]\n/ or die "ext $nome";
}

sub material_triplanar {
	my ($nome, $textura, $escala) = @_;
	$t =~ s/\[sub_resource type="StandardMaterial3D" id="\Q$nome\E"\]\n(?:(?!\[)[^\n]*\n)*//;
	my $escala_y = $nome eq "concreto" ? $escala : -$escala;
	my $bloco = "[sub_resource type=\"StandardMaterial3D\" id=\"$nome\"]\nalbedo_texture = ExtResource(\"$id{$textura}\")\nuv1_scale = Vector3($escala, $escala_y, $escala)\nuv1_triplanar = true\nuv1_world_triplanar = true\ntexture_filter = 0\n\n";
	$t =~ s/(\[node name="Main" type="Node3D"\]\n)/$bloco$1/ or die "material $nome";
}
material_triplanar("concreto", "concreto", 0.5);
material_triplanar("rua", "rua", 0.25);
material_triplanar("tapume", "tapume", 0.4);
material_triplanar("ferro_velho", "ferro_velho", 0.4);
for my $v (qw(a b c)) {
	material_triplanar("loja_$v", "loja_$v", 0.2857);
	material_triplanar("andar_$v", "andar_$v", 0.25);
}
unless ($t =~ /id="horizonte"\]/) {
	$t =~ s/(\[node name="Main" type="Node3D"\]\n)/[sub_resource type="StandardMaterial3D" id="horizonte"]\nalbedo_color = Color(0.55, 0.6, 0.68, 1)\n\n$1/;
}
$t =~ s/(\[sub_resource type="StandardMaterial3D" id="chao"\]\nalbedo_texture = ExtResource\(")[^"]+("\))/$1$id{calcada}$2/;

$t =~ s/\[node name="[^"]*"[^\n]*parent="Fundo(?:\/[^"]*)?"[^\n]*\]\n(?:(?!\[)[^\n]*\n)*//g;

my $f = '';
my $k = 0;
sub caixa {
	my ($x, $y, $z, $w, $h, $p, $mat) = @_;
	$k++;
	$f .= "[node name=\"Caixa$k\" type=\"CSGBox3D\" parent=\"Fundo\"]\nposition = Vector3($x, $y, $z)\nsize = Vector3($w, $h, $p)\nmaterial = SubResource(\"$mat\")\n\n";
}
sub sprite {
	my ($textura, $x, $y_base, $z, $px, $altura_px, $extra) = @_;
	$k++;
	my $y = $y_base + $altura_px * $px / 2.0;
	$extra //= '';
	$f .= "[node name=\"Objeto$k\" type=\"Sprite3D\" parent=\"Fundo\"]\nposition = Vector3($x, $y, $z)\npixel_size = $px\nalpha_cut = 1\ntexture_filter = 0\ntexture = ExtResource(\"$id{$textura}\")\n$extra\n";
}
sub letreiro {
	my ($texto, $x, $y, $z, $tamanho, $cor) = @_;
	$k++;
	$f .= "[node name=\"Letreiro$k\" type=\"Label3D\" parent=\"Fundo\"]\nposition = Vector3($x, $y, $z)\npixel_size = 0.01\nmodulate = Color($cor)\ntext = \"$texto\"\nfont_size = $tamanho\noutline_size = 16\n\n";
}

# Rua, calçada de trás e meio-fio da rua.
caixa(85, -0.15, -4.5, 200, 0.3, 5, "rua");
caixa(85, 0.0, -7.75, 200, 0.3, 1.5, "chao");

# Fachada contínua de prédios com loja no térreo.
my $x = -12;
my @variantes = qw(a b c);
my $i = 0;
while ($x < 186) {
	my @larguras = (5, 6, 7, 8);
	my $w = $larguras[int(rand(@larguras))];
	my @alturas = (3.5, 4.5, 6, 7.5, 9);
	my $h = $alturas[int(rand(@alturas))];
	my $v = $variantes[$i % 3];
	my $c = $x + $w / 2;
	caixa($c, 1.75, -10.5, $w - 0.1, 3.5, 5, "loja_$v");
	caixa($c, 3.5 + $h / 2, -10.5, $w - 0.1, $h, 5, "andar_" . $variantes[($i + 1) % 3]);
	sprite("toldo", $c - $w / 4, 3.05, -7.95, 0.12, 8);
	$x += $w;
	$i++;
}

# Trecho 1, rua comercial: assistência técnica, banca, orelhão e ipê.
letreiro("ASSISTÊNCIA TÉCNICA", 8.5, 5.0, -7.9, 64, "1, 0.95, 0.75, 1");
letreiro("CONSERTO DE NOTEBOOK", 8.5, 4.45, -7.9, 40, "0.75, 0.9, 1, 1");
sprite("banca", 9.5, 0.1, -6.8, 0.06, 34);
sprite("orelhao", 23, 0.1, -6.9, 0.06, 34);
sprite("arvore", 30, 0.1, -6.6, 0.09, 44);
sprite("lixeira", -2.5, 0, -1.6, 0.053, 20);
sprite("poste", -1, 0, -1.8, 0.053, 70);
sprite("poste", 20, 0, -1.8, 0.053, 70);
letreiro("BAR", 17, 4.6, -7.9, 64, "1, 0.85, 0.4, 1");

# Trecho 2, descarte irregular.
for my $p ([37.4, 0], [38.2, 0], [48, 0], [48.7, 0], [55.3, 0]) {
	sprite("saco", $p->[0], $p->[1], -1.7, 0.053, 12);
}
letreiro("PROIBIDO JOGAR LIXO", 50, 2.9, -7.9, 44, "1, 0.6, 0.5, 1");
sprite("lixeira", 36.6, 0, -1.6, 0.053, 20);

# Trecho 3, ferro-velho.
sprite("sucata", 86.5, 0, -1.8, 0.06, 30);
sprite("bobina", 92.2, 0, -1.7, 0.053, 20);

# Trecho 4, obra do abismo.
for my $p (105.4, 105.9, 118.5, 119.0) {
	sprite("cone", $p, 0.0, -1.5, 0.053, 14);
}

# Trecho 5, fiação: postes com fios emaranhados até o chão eletrificado.
for my $p (120, 128, 136, 144, 152, 160) {
	sprite("poste", $p, 0, -2.6, 0.06, 70);
}
for my $p (124, 132, 140, 148, 156) {
	sprite("fiacao", $p, 2.7, -2.65, 0.03125, 48);
}
sprite("bobina", 146.8, 0, -1.7, 0.053, 20);

# Trecho 6, cooperativa de reciclagem.
letreiro("COOPERATIVA DE RECICLAGEM", 169, 5.6, -7.6, 64, "0.6, 1, 0.65, 1");
for my $p ([161.5, -6.7], [163, -6.7], [170, -6.7], [171.4, -6.7], [169, -1.9]) {
	sprite("bag", $p->[0], 0.1, $p->[1], 0.06, 24);
}

# Fundo distante: morros e horizonte.
sprite("morro", 30, 2, -60, 0.6, 50, "modulate = Color(0.85, 0.88, 0.95, 1)\n");
sprite("morro", 135, 3, -65, 0.65, 50, "modulate = Color(0.82, 0.86, 0.94, 1)\n");
my $hx = -30;
while ($hx < 210) {
	my $w = 6 + int(rand(8));
	my $h = 8 + int(rand(16));
	caixa($hx + $w / 2, $h / 2, -34, $w, $h, 4, "horizonte");
	$hx += $w + 1 + int(rand(3));
}

$t =~ s/(\[node name="Fundo" type="Node3D" parent="\."\]\n\n)/$1$f/ or die "fundo";

open(my $s, '>:encoding(UTF-8)', $arquivo) or die;
print $s $t;
close($s);
print "ok, $k nós\n";
