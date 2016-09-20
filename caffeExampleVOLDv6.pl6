use v6;
# change for Rakudo 2012.10 and erlier on Parrot: 'next' not implemented yet

my $start = BEGIN now;
my $finish = 'c,lrc,lctcml,lrlmlc,cctel,lme,mem,et,crm,lcr,cll,edlc,tccm,clmd,r,tl,dc,elcc.t,elc,mcl,ctcrlc,ltcm,ccc,lc,r,cdcc,dlrcm,mlm,dll,cm,lrl,cl,mdlm,lcr,lle,cec,de,lcd,cld,ltmc.lc,rc,c,lll,dce,lc,tcd,le,clc,cmmer,ctc,ccl,lc,mrm,dce,ldc,cdec,cdel,cr,lll,dctcr,lmc,llc,dc,rccr,ccdlmc,lmcl,rle,c,tc,c,cldl,m,cmr,dlld,mclc,md,lcc,elm,cll,cde,lrc,ml,dem,cd,me,l,mcd,lm,tccl,cml,dcme,mcr,ee,l,dtcde,dele,lcmd,dc,l,drm,dtml,mc,mlrl,lcm,ecr,rlc,ecc,edc,re,cce,edcm,ll,cctlr,cc,lrce,ce,mrl,dml,ddc,mc,ltcc,mc,lcd,e,mmctrc,lcdm,cmr,lc,erld,erc,rcec,rcl,dr,ctc,cm,crrd,llccr,mc,cdl,cctceml,cd,meclr,ecdc,cl,lrtcl,ecr,cc,erl,l,cr,ltmm,m,rlde,ler,cdl,rcl,ecec,clc,ctrc,cl,cd,ccc,cr,rcted,le,cdcrm,rcc,rle,ecc,mll,cl,clcc,er,dcr,c,lccd,etlce,rcd,lcrc,mcr,eld,rl,mec,cm,elccl,r,lec,ltcr,c,mcld,me,ede,lcm,ltec,ccl,cmtm,clm,ecc,rttrd,rcld,mlm,ec,rd,ltdl,le,emd,el,';

my @LOG;

sub log( Str $txt ) { push @LOG, "$txt\n" }

my %coffeesHOW = 
	'espresso' => { :ground(7), :water(25), :time(25), :glass(60), :prepareTime(25+40) },
	'doppio' => { :ground(14), :water(50), :time(25), :glass(60), :prepareTime(25+40) },
	'ristretto' => { :ground(7), :water(12), :time(25), :glass(60), :prepareTime(25+40) },
	'double ristretto' => { :ground(14), :water(25), :time(25), :glass(60), :prepareTime(25+40) },
	'lungo' => { :ground(7), :water(50), :time(50), :glass(60), :prepareTime(25+40) },
	'cafe macchiato' => { :ground(7), :water(25), :milk(2), :glass(60), :prepareTime(25+40) },
	'cappucino' => { :ground(7), :water(25), :milk(60), :glass(160), :prepareTime(25+60) },
	'latte' => { :ground(7), :water(25), :milk(120), :glass(280), :prepareTime(25+60) },
	'latte macchiato' => { :ground(7), :water(25), :milk(100), :glass(250), :prepareTime(25+20+240) },
	'amaricana' => { :base('espresso'), :water(25), :glass(60), :prepareTime(25+40) };

sub coffeeKnowHow( Str $name ) {
	if $name eq any(%coffeesHOW.keys) {
		return %coffeesHOW{$name};
	}
}

class Fluid {
	has $.temperature is rw;
	has Int $.volume is rw;
	method dose( int $volume ) {}
	method warm( int $volume ) {}
}
class Water is Fluid {
	method boil() { self.temperature = 100 }
}
class Milk is Fluid {
	method steam() { 
		$.temperature = 70;
		$.volume *= 2;
		log "Micro boubles!";
	}
}
class Drink is Fluid {
}
class Coffee is Drink {
	has Str $.name is rw;
	method name( $n ) { $!name = $n; }
}
class Tea is Drink {
}

class Dish {
	has @.content is rw;
	has Int $.prepareTime;
	method fill( $d ) { push @!content, $d; }
	method clean() { log( "Work, work, work..." ); }
	method pour() { shift @!content; }
}
class Glass is Dish {
	has $!volume;
	has $!temperature;
	has Drink $.content;
	method warm() { self.temperature = 60; }
}
class Plate is Dish {
	method put() {}
}
class Jug is Dish {
	method steamMilk() { @.content[0].steam() }
}
class Spoon {
		has $!volume;
	method place() {}
	method clean() { log( "Work, work, work..." ); }
}

class Portafilter {
	has $!ground;
	has $!basketType;
	has Bool $!dirty = False;
	method fill( Int $grams ) { $!ground = $grams; }
	method filter( Water $water ) returns Coffee {
		return Coffee.new( :volume( $water.volume ), :temperature(67) );
	}
	method clean() { log( "Work, work, work..." ); }
}

class Beans {
	has $.weight;
	has $.name;
}
class GroundBeans is Beans {
	has $.weight;
}

class CoffeeMill {
	method turnOn() {}
	method turnOff() {}
	method grind() {}
	method dose( int $weight ) returns GroundBeans {}
	method fill( Beans $beans ) { log "Mmm, fresh beans..." }
	method clean() {  log( "Work, work, work..." ); }
}

class Boiler {
	has $!temperature = 120;
	has $.boilerVolume;
	method fill() {}
	#method takeWater( Int $amount ) returns Water {
	method takeWater( Int $v ) returns Water {
		log "Water for new brew";
		return Water.new( :volume( $v ) );
	}
}

class EspressoMachine {
	has Int $!numGroups;
	has Boiler $!boiler;
	has Bool $!power;
	method steamOn() { }
	method steamOff() { }
	method brew( Portafilter $p, $amount, $name ) returns Coffee {  # via group head
			log "Pump started";
			my Water $w = $!boiler.takeWater( $amount );
			my Coffee $c = $p.filter( $w );
			$c.name( $name );
			log "Pump turned off";
			return $c;
	}
	method doseWater( Int $volume ) {}  # from hot water tap 
	method clean() { log("Work, work, work..."); }
	method turnOn() { log "On" }
	method turnOff() { log "Off" }
	method warm() { "Warming"; }
}

class Order {
	has int $.status;
	has Str @.list;
	has Glass @.order is rw;
}

class Customer { ... }

class Barista {
	has Str $!name; 
	has Int $.workTime is rw;
	has EspressoMachine $.machine is rw;
	has Portafilter $.single is rw;
	has Portafilter $.double is rw;
	has CoffeeMill $.mill;
	has Order @.list;
	method takeOrder( Order $order is rw ) returns Bool {
			if $.workTime > 8*60*60 {
				log "Sorry, we are closed";
				#say "Sorry, we are closed";
				return False;
			}
			push @.list, $order;
			log "Order accepted";
			True;
	}
	method makeTea() returns Tea {
			my $t = Tea.new();
			$t.volume  = 240 ;
			$t.temperature = 98;
			log "Tea ready";
			return $t;
	}
	method serve( Customer $customer ) {
		log "Enjoy!";
		my $g = shift self.list;
		$customer.drinks = $g.order;
		1;
	}
	method rest( Int $time ) returns Int { $time * 60; }
	method makeDrinks() {
		log "Preparing drinks";
		my Order $o = @.list[0];
		for $o.list -> $name {
			if $name eq "tea" {
				my $g = Glass.new( :prepareTime(60) );
				$g.fill( self.makeTea() );
				$.workTime += $g.prepareTime;
				push $o.order, $g;
			} else {
				my $kh = coffeeKnowHow( $name );
				if ! $kh {
						log( "We don't have this on menu" );
						#next;
				} else {;
					my $g = Glass.new( :volume($kh<glass>), :temperature(40), :prepareTime($kh<prepareTime>) );
					if $kh<ground> == 7 {
						$.single.fill( 7 );
						my $b = $.machine.brew( $.single, $kh<water>, $name );
						$g.fill( $b );
					} else {
						$.double.fill( 14 );
						my $b = $.machine.brew( $.double, $kh<water>, $name );
						$g.fill( $b );
					}

					if $kh<milk> {
						my $j = Jug.new;
						$j.fill( Milk.new( :volume( $kh<milk> ) ) );
						$j.steamMilk();
						$g.fill( $j.pour() );
					}
					$.workTime += $g.prepareTime;
					push $o.order, $g;
				}
			}
		}	
	}
};

class Customer {
	has $.id is rw;
	has Glass @.drinks is rw;
	method orderDrink( Barista $b, Order $o is rw ) returns Bool {
		log "Beverages pleas";
		$b.takeOrder( $o ) or return False;
		$.id++;
		True;
	}
	method drink() {
		#say (shift @.drinks).perl;
		shift @.drinks;
		log "Gulp, gulp, gulp";
	}
	method wait() { log( "Waiting..." ) }
}

# Main

# Tools
my $bo = Boiler.new( :temperature(120), :boilerVolume( 1500 ) );
my $e = EspressoMachine.new( :boiler( $bo ) );
my $ps = Portafilter.new( :basketType('single') );
my $pd = Portafilter.new( :basketType('double') );
my $j = Jug.new();
my $beans = Beans.new( :name<Locally grown, fair organic Arabica>, :weight(500) ); 
my $m = CoffeeMill.new();
$m.fill( $beans );

# Barista
my $barista = Barista.new( :machine( $e ), :single( $ps ), :double( $pd ), :workTime( 0 ) );

$e.turnOn();
$e.warm(); # 20 min

my $customer = Customer.new();


my @n;
my @k;
for $finish.comb -> $l {
	given $l {
		when ',' { push @n, @k; @k = (); }
		when 'e' { push @k, 'espresso' }
		when 'r' { push @k, 'ristretto' }
		when 'd' { push @k, 'doppio' }
		when 'c' { push @k, 'cappucino' }
		when 'l' { push @k, 'latte' }
		when 'm' { push @k, 'latte macchiato' }
		when 't' { push @k, 'tea' }
	}
}

for @n -> $l {
	my Order $o = Order.new( :list(@$l) );
	$customer.orderDrink( $barista, $o ) or last;
	$barista.makeDrinks();
	$barista.serve( $customer );
	$customer.drink();
}

#say ~@LOG;

say now - $start;

#dd $customer;

#=finish
