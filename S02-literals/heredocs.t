use Test;
plan 10;

my $foo = "FOO";
my $bar = "BAR";

sub no-r(Str $in) { $in.subst(/\r/, '', :g) }

# L<S02/Heredocs/Heredocs are no longer written>
{ # qq:to
    my @q = ();

    @q = qq:to/FOO/;
blah
$bar
blah
$foo
FOO

    is(+@q, 1, "q:to// is singular");
    is(no-r(@q[0]), "blah\nBAR\nblah\nFOO\n", "here doc interpolated");
};

{ # qq:to
    my @q = ();

    @q = qq:to/FOO/;
        blah
        $bar
        blah
        $foo
        FOO

    is(no-r(@q[0]), "blah\nBAR\nblah\nFOO\n", "here doc interpolating with indentation");
};

# L<S02/Optional whitespace/Heredocs allow optional whitespace>
{ # q:to indented
    my @q = ();

    @q = q:to/FOO/;
        blah blah
        $foo
        FOO

    is(+@q, 1, "q:to// is singular, also when indented");
    is(no-r(@q[0]), "blah blah\n\$foo\n", "indentation stripped");
};

{ # q:heredoc backslash bug
        my @q = q:heredoc/FOO/
yoink\n
splort\\n
FOO
;
        is(+@q, 1, "q:heredoc// is singular");
        is(no-r(@q[0]), "yoink\\n\nsplort\\n\n", "backslashes");
}

my $multiline = "Hello\nWorld";

# some dedent tests
{
    my @q = qq:to/END/;
        first line
        $multiline
        another line
        END

    is no-r(@q[0]), "first line\nHello\nWorld\nanother line\n", "indent with multiline interpolation";
}

$multiline = "Hello\n    World";
{
    my @q = qq:to/END/;
        first line
        $multiline
        another line
        END

    is no-r(@q[0]), "first line\nHello\n    World\nanother line\n", "indent with multiline interpolation with spaces at the beginning";
}
{
    my @q = qq:to/END/;
        first line
        $multiline        something
        another line
        END

    is no-r(@q[0]), "first line\nHello\n    World        something\nanother line\n", "extra spaces after interpolation will be kept";
}