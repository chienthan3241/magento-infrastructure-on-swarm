# Changes for Go-Live in Production

2018-05-18 kg

## User www-data

    groupadd -g 33 www-data
    useradd -g 33 -u 33 www-data

Add ssh keys to `/home/www-data/.ssh/authorized_keys`.
Make sure to add `from="127.0.0.1,::1` to the keys.

## Inside php containers

    composer

home dir `/var/www` not writable, composer can't store credentials.
