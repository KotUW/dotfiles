#!/bin/env perl
use strict;
use warnings;
use Term::ANSIColor qw(:constants);

print BOLD, UNDERLINE, "Upgrade manager v2 \n", RESET ;

my $lock_file = "//home/eve/.cache/upgrade.lock";

# test if lock file is older than 5 day or does not exists
if (!-e $lock_file || (-M $lock_file) > 5) {
    touch_lock();

    update_distro();
    update_flatpak();
    update_uv();
    update_firmware();
} else {
    print RED, "Lockfile is still younger, Please wait ", (5 - (-M $lock_file))*60, " hours.\n", RESET;
    }

sub update_uv {
    print UNDERLINE, "Updating UV python tools\n", RESET;
    if (not command_exists("uv")) {
        print "uv not found";
        return;
    }
    my $uv_list_output = `uv tool list | rg ' v' | cut -f1 -d' '`;
    my @uv_list = split(' ', $uv_list_output);
    foreach my $uv (@uv_list) {
        system("uv tool upgrade $uv");
    }
}

sub update_distro {
    print UNDERLINE, "Updating distro\n", RESET;
    if (not command_exists("pacman")) {
        print "pacman not found";
        return;
    }
    system("sudo pacman -Syu --noconfirm");

    print UNDERLINE, "Removing unwanted packages\n", RESET;
    system("sudo pacman -Rnc \$(pacman -Qdtq) --noconfirm");

    print BOLD, "\nThis doesn't touch AUR.\n", RESET;
}

sub update_flatpak {
    print UNDERLINE, "Updating Flatpacks\n", RESET;
    if (not command_exists("flatpak")) {
        print "flatpak not found";
        return;
    }
    system("flatpak upgrade --noninteractive");

    print UNDERLINE, "Removing unwanted packages\n", RESET;
    system("flatpak uninstall --unused --delete-data");
}

sub update_firmware {
    print UNDERLINE, "Updating firmware\n", RESET;
    system("fwupdmgr refresh && fwupdmgr update");
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
