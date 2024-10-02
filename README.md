# ATG Canvas Course Enable APP
This repository is used to enable apps in the canvas side nav for courses
## Usage
You can use the jupyter notebook or the bash script to change the app visibility. You will need to run a SQL query and export the data into a CSV with `id`, `course_code`, `enrollment_term_id` as the columns.
```sql
select id, course_code, enrollment_term_id
from canvas.courses can,
where can.tab_configuration like '%{"id":"context_external_tool_<tool id>","hidden":true}%' and enrollment_term_id='<term id>'
```

### Bash script
If you are opting to use the bash script you will will need to supply the bash command with the following:
- `-f` with the file path
- `-h` with the host path similar to the jupyter notebook example
- `-k` with the api key generated from canvas
- `-t` with the app tool id(can be found in the canvas data 2 or directly in canvas)

```bash
bash atg_canvas_course_enable_app.sh -f ../beta_canvas_fall_2024_2025.csv -h 'school.canvas.com' -k 'some-super-secret-key' -t 99999
```
