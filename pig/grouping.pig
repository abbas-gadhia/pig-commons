DEFINE COUNT_GROUP(relation, group_fields) RETURNS G {
  gr = group $relation BY ($group_fields);
  gen_gr = FOREACH gr GENERATE
    flatten(group);
  gen_gr_all = GROUP gen_gr ALL;
  $G = FOREACH gen_gr_all GENERATE COUNT(gen_gr);
};

DEFINE TOP_GROUPS(relation, group_fields, limit_val) RETURNS T {
  gr = group $relation BY ($group_fields);

  gen_gr = FOREACH gr GENERATE
    group AS gr_fields,
    COUNT($relation) as cnt,
    $relation as relation;

  high_groups = FILTER gen_gr BY cnt > 1;

  ordered_groups = ORDER high_groups BY cnt DESC;

  $T = LIMIT ordered_groups $limit_val;
};