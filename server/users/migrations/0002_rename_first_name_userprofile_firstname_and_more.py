# Generated by Django 5.1.2 on 2024-10-13 20:33

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0001_initial'),
    ]

    operations = [
        migrations.RenameField(
            model_name='userprofile',
            old_name='first_name',
            new_name='firstName',
        ),
        migrations.RenameField(
            model_name='userprofile',
            old_name='last_name',
            new_name='lastName',
        ),
    ]
