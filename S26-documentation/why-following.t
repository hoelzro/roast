use Test;
plan 22;

class Simple {
#= simple case
}

is Simple.WHY.content, 'simple case';
is ~Simple.WHY, 'simple case', 'stringifies correctly';

class Outer {
#= giraffe
    class Inner {
    #= zebra
    }
}

is Outer.WHY.content, 'giraffe';
is Outer::Inner.WHY.content, 'zebra';

module foo {
#= a module
    package bar {
    #= a package
        class baz {
        #= and a class
        }
    }
}

is foo.WHY.content,           'a module';
is foo::bar.WHY.content,      'a package';
is foo::bar::baz.WHY.content, 'and a class';

sub marine {} #= yellow
is &marine.WHY.content, 'yellow';

sub panther {}
#= pink
is &panther.WHY.content, 'pink';

class Sheep {
#= a sheep
    has $.wool; #= usually white

    method roar { 'roar!' }
    #= not too scary
}

is Sheep.WHY.content, 'a sheep';
is Sheep.^attributes.grep({ .name eq '$!wool' })[0].WHY, 'usually white';
is Sheep.^find_method('roar').WHY.content, 'not too scary';

sub routine {}
is &routine.WHY.defined, False;

our sub oursub {}
#= our works too
is &oursub.WHY, 'our works too', 'works for our subs';

# two subs in a row

sub one {}
#= one

sub two {}
#= two
is &one.WHY.content, 'one';
is &two.WHY.content, 'two';

sub first {}
#= that will break

sub second {}
#= that will break

is &first.WHY.content, 'that will break';
is &second.WHY.content, 'that will break';

sub third {}
#=      leading space here
is &third.WHY.content, 'leading space here';

sub has-parameter(
    Str $param
    #= documented
) {}

is &has-parameter.signature.params[0].WHY, 'documented';

sub has-parameter-as-well(
    Str $param #= documented as well
) {}

is &has-parameter-as-well.signature.params[0].WHY, 'documented as well';

sub so-many-params(
    Str $param, #= first param
    Int $other-param
) {}

is &so-many-params.signature.params[0].WHY, 'first param';