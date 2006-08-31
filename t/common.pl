#!perl

use strict;
use warnings;
use Scalar::Util qw( blessed );

sub show_attribute {
    my ($attr) = @_;

    if (blessed $attr && $attr->isa('Linux::Sysfs::Attribute')) {
        if (my $value = $attr->value) {
            chomp $value;
            diag(sprintf 'Attr "%s" at "%s" has a value "%s"',
                    $attr->name, $attr->path, $value);
        }
    }
}

sub show_attribute_list {
    my ($attrs) = @_;

    for my $attr (@{ $attrs || [] }) {
        show_attribute($attr);
    }
}

sub show_device {
    my ($dev) = @_;

    if (blessed $dev && $dev->isa('Linux::Sysfs::Device')) {
        diag(sprintf 'Device is "%s" at "%s"', $dev->name, $dev->path);
    }
}

sub show_device_list {
    my ($devices) = @_;

    for my $dev (@{ $devices || [] }) {
        show_device($dev);
    }
}

sub show_driver {
    my ($drv) = @_;

    if (blessed $drv && $drv->isa('Linux::Sysfs::Driver')) {
        diag(sprintf 'Driver is "%s" at "%s"', $drv->name, $drv->path);
    }
}

sub show_driver_list {
    my ($drivers) = @_;

    for my $drv (@{ $drivers || [] }) {
        show_driver($drv);
    }
}

sub show_class_device {
    my ($classdev) = @_;

    if (blessed $classdev && $classdev->isa('Linux::Sysfs::ClassDevice')) {
        diag(sprintf 'Class device "%s" belongs to the "%s" class', $classdev->name, $classdev->classname);
    }
}

sub show_module {
    my ($module) = @_;

    if (blessed $module && $module->isa('Linux::Sysfs::Module')) {
        diag(sprintf 'Module name is %s, path is %s', $module->name, $module->path);
        show_attribute_list([$module->get_attributes]);
        show_parm_list([$module->get_parms]);
        show_section_list([$module->get_sections]);
    }
}

sub show_parm_list {
    my ($parms) = @_;

    for my $parm (@{ $parms || [] }) {
        diag($parm->name);
    }
}

sub show_section_list {
    my ($sections) = @_;

    for my $sect (@{ $sections || [] }) {
        diag($sect->name);
    }
}

1;
