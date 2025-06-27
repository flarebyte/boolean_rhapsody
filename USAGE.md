# Usage

## Function Reference & Usage Hints

| **Function**                    | **Category**  | **Usage Hint**                                                                  |
| ------------------------------- | ------------- | ------------------------------------------------------------------------------- |
| `is_absent`                     | Presence      | `is_absent(env:var)` – true if the variable is not defined                      |
| `is_present`                    | Presence      | `is_present(env:var)` – true if the variable is defined                         |
| `is_empty_string`               | String        | `is_empty_string(env:field)` – true if empty                                    |
| `is_trimmable_string`           | String        | `is_trimmable_string(env:field)` – true if contains leading/trailing spaces     |
| `is_complex_unicode`            | String        | `is_complex_unicode(env:field)` – true if has non-ASCII Unicode                 |
| `is_simple_unicode`             | String        | `is_simple_unicode(env:field)` – true if ASCII-compatible only                  |
| `is_allowed_chars`              | String        | `is_allowed_chars(env:field, config:allowedChars)` – checks allowed characters  |
| `is_multiple_lines`             | String        | `is_multiple_lines(env:field)` – contains newline                               |
| `is_single_line`                | String        | `is_single_line(env:field)` – no newline characters                             |
| `is_numeric`                    | Number/String | `is_numeric(env:field)` – parses as number                                      |
| `is_integer`                    | Number/String | `is_integer(env:field)` – parses as integer                                     |
| `is_date_time`                  | String        | `is_date_time(env:timestamp)` – ISO 8601 or similar format                      |
| `is_url`                        | String        | `is_url(env:link, config:flags, config:allowedDomains)` – optional flags/domain |
| `contains_substring`            | String        | `contains_substring(env:text, config:term)`                                     |
| `starts_with_prefix`            | String        | `starts_with_prefix(env:text, config:prefix)`                                   |
| `ends_with_suffix`              | String        | `ends_with_suffix(env:text, config:suffix)`                                     |
| `string_equals`                 | String        | `string_equals(env:actual, config:expected, config:ignoreCase)`                 |
| `number_equals`                 | Number        | `number_equals(env:value, config:threshold)`                                    |
| `number_not_equals`             | Number        | `number_not_equals(env:value, config:threshold)`                                |
| `number_greater_than`           | Number        | `number_greater_than(env:value, config:threshold)`                              |
| `number_greater_than_equals`    | Number        | `number_greater_than_equals(env:value, config:threshold)`                       |
| `number_less_than`              | Number        | `number_less_than(env:value, config:threshold)`                                 |
| `number_less_than_equals`       | Number        | `number_less_than_equals(env:value, config:threshold)`                          |
| `date_time_equals`              | DateTime      | `date_time_equals(env:ts, config:compareTo)`                                    |
| `date_time_not_equals`          | DateTime      | `date_time_not_equals(env:ts, config:compareTo)`                                |
| `date_time_greater_than`        | DateTime      | `date_time_greater_than(env:ts, config:after)`                                  |
| `date_time_greater_than_equals` | DateTime      | `date_time_greater_than_equals(env:ts, config:afterOrEqual)`                    |
| `date_time_less_than`           | DateTime      | `date_time_less_than(env:ts, config:before)`                                    |
| `date_time_less_than_equals`    | DateTime      | `date_time_less_than_equals(env:ts, config:beforeOrEqual)`                      |
| `list_size_equals`              | List          | `list_size_equals(env:items, config:size)`                                      |
| `list_size_not_equals`          | List          | `list_size_not_equals(env:items, config:size)`                                  |
| `list_size_greater_than`        | List          | `list_size_greater_than(env:items, config:minSize)`                             |
| `list_size_greater_than_equals` | List          | `list_size_greater_than_equals(env:items, config:minSize)`                      |
| `list_size_less_than`           | List          | `list_size_less_than(env:items, config:maxSize)`                                |
| `list_size_less_than_equals`    | List          | `list_size_less_than_equals(env:items, config:maxSize)`                         |
| `set_equals`                    | Set           | `set_equals(env:setA, config:setB)`                                             |
| `is_subset_of`                  | Set           | `is_subset_of(env:subset, config:superset)`                                     |
| `is_superset_of`                | Set           | `is_superset_of(env:superset, config:subset)`                                   |
| `is_disjoint`                   | Set           | `is_disjoint(env:setA, config:setB)`                                            |
