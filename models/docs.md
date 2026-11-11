{% docs __overview__ %}
# Интернет-магазин

PostgreSQL -> raw -> staging -> intermediate -> marts в Greenplum.
Два факта и три измерения. Тестовые заказы исключены.
{% enddocs %}

{% docs confirmed_order %}
Заказ paid с хотя бы одной успешной оплатой без возврата.
Возврат - успешная операция с отрицательной суммой.
{% enddocs %}
