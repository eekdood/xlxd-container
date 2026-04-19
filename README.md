# xlxd-container

Run XLXd in Docker with either `dashboard1` or `dashboard2`, plus simple runtime config files.

## Quick Start

1. Edit `docker-compose.yml`
2. Start the container:

```bash
docker compose up -d
```

3. After first start, edit the files in:

```text
xlxd/config
```

4. Restart if needed:

```bash
docker compose restart
```

## Main Settings

These are the settings most people will care about in `docker-compose.yml`:

- `DASHBOARD`
- `XLXNUM`
- `APACHE_PORT`
- `CALLHOME`
- `EMAIL`
- `URL`
- `COUNTRY`
- `DESCRIPTION`
- `MODULEA`
- `MODULEB`
- `MODULEC`
- `MODULED`

## Dashboard Selection

Use one of:

- `DASHBOARD=dashboard1`
- `DASHBOARD=dashboard2`

If `DASHBOARD` is blank or invalid, XLXd still runs but no dashboard is installed.

## Runtime Files

Dashboard settings are stored in:

```text
xlxd/config/dashboard1.ini
xlxd/config/dashboard2.ini
```

Edit those files after the first run if you want to change dashboard behavior.

## Notes

- this repo packages XLXd; upstream source lives at `LX3JL/xlxd`
