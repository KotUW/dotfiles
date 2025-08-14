#!/bin/env perl
use strict;
use warnings;
use Term::ANSIColor qw(:constants);

print BOLD, UNDERLINE, MAGENTA, "Upgrade manager v2.5 \n", RESET ;

my $lock_file = "//home/eve/.cache/upgrade.lock";

# test if lock file is older than 5 day or does not exists
if (!-e $lock_file || (-M $lock_file) > 5) {
    update_distro();
    update_flatpak();
    update_uv();
    update_firmware();
    update_rust();
    touch_lock();
} else {
    print RED, "Lockfile is still younger, Please wait ", (5 - (-M $lock_file))*60, " hours.\n", RESET;
    }

sub update_uv {
    print UNDERLINE, BLUE,  "Updating UV python tools\n", RESET;
    if (not command_exists("uv")) {
        print "uv not found";
        return;
    }
        system("uv tool upgrade --all");
}

sub update_distro {
    print UNDERLINE, BLUE,  "Updating distro\n", RESET;
    if (not command_exists("pacman")) {
        print "pacman not found";
        return;
    }
    system("sudo pacman -Syu --noconfirm");

    print UNDERLINE,BLUE,   "Removing unwanted packages\n", RESET;
    system("sudo pacman -Rnc --noconfirm \$(pacman -Qdtq)");

    print BOLD, RED, "\nThis doesn't touch AUR.\n", RESET;
}

sub update_flatpak {
    print UNDERLINE, BLUE,  "Updating Flatpacks\n", RESET;
    if (not command_exists("flatpak")) {
        print "flatpak not found";
        return;
    }
    system("flatpak upgrade --noninteractive");

    print UNDERLINE, BLUE,  "Removing unwanted packages\n", RESET;
    system("flatpak uninstall --unused --delete-data");
}

sub update_firmware {
    print UNDERLINE, BLUE,  "Updating firmware\n", RESET;
    system("fwupdmgr refresh && fwupdmgr get-updates");
}

sub update_rust{
    print UNDERLINE, BLUE,  "Updating rust toolchain\n", RESET;
    system("rustup update");
}
# create lock file or modify acces time of the lockfile
sub touch_lock{
    open my $fh , '>', $lock_file or die "Cannot open lock file: $!";
    print $fh "lock";
    close $fh;
    print "lock file modified\n";
}

sub command_exists {
    my ($cmd) = shift;
    return 0 unless defined $cmd and $cmd ne '';

    my $which_output = `which $cmd 2>/dev/null`;
    chomp($which_output);

    return $which_output ne '' && -x $which_output ? 1 : 0;
}
