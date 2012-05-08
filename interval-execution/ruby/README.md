# Interval Execution

Goal: Run something every N seconds.

This is common for heartbeats, metric emission, etc.

## Implementations

### Naive implementation 

Code: [interval1.rb](https://github.com/jordansissel/software-patterns/blob/master/interval-execution/ruby/examples/interval1.rb)

This implementation unfortunately really says "After 'code' is done, sleep N
seconds" which is not what we want. You get clock skew:

```ruby
% ruby run.rb 1
{:duration=>1.200278292, :skew=>0.1002166980000001, :count=>1, :avgskew=>0.1002166980000001}
{:duration=>1.100280308, :skew=>0.20051446100000003, :count=>2, :avgskew=>0.10025723050000002}
{:duration=>1.100246679, :skew=>0.3007792509999998, :count=>3, :avgskew=>0.10025975033333327}
{:duration=>1.100247607, :skew=>0.4010443800000001, :count=>4, :avgskew=>0.10026109500000002}

...

{:duration=>1.100216171, :skew=>2.706705176, :count=>27, :avgskew=>0.10024833985185184}
{:duration=>1.100220347, :skew=>2.806943812, :count=>28, :avgskew=>0.10024799328571429}
{:duration=>1.100225218, :skew=>2.9071880169999993, :count=>29, :avgskew=>0.1002478626551724}
{:duration=>1.10022926, :skew=>3.007439372999997, :count=>30, :avgskew=>0.1002479790999999}
```

The above gives us an average skew of 0.1002 seconds per iteration, that's
quite a bit. After 30 seconds, we're behind the real time clock by almost 3
seconds.

Notice the duration of about 1.1 seconds. This is because 'run.rb' is running
some code that takes 0.1 seconds to complete, so this naive implementation
actually invokes the block every 1.1 seconds! Oops!

### Better implementation

Code: [interval2.rb](https://github.com/jordansissel/software-patterns/blob/master/interval-execution/ruby/examples/interval2.rb)

This implementation tracks the duration of the block call and tries to
compensate by sleeping less. It sleeps the interval time minus the block call
duration.

```
% ruby run.rb 2
{:duration=>1.100209475, :skew=>0.0001255790000000978, :count=>1, :avgskew=>0.0001255790000000978}
{:duration=>1.000071029, :skew=>0.00021426700000004573, :count=>2, :avgskew=>0.00010713350000002286}
{:duration=>1.000075607, :skew=>0.0003079299999999563, :count=>3, :avgskew=>0.00010264333333331876}
{:duration=>1.000072835, :skew=>0.00039882999999996116, :count=>4, :avgskew=>9.970749999999029e-05}

...

{:duration=>1.000097278, :skew=>0.003274076000000292, :count=>27, :avgskew=>0.0001212620740740849}
{:duration=>1.000099535, :skew=>0.003407560999999504, :count=>28, :avgskew=>0.00012169860714283942}
{:duration=>1.000098096, :skew=>0.0035369729999992217, :count=>29, :avgskew=>0.00012196458620686971}
{:duration=>1.000101167, :skew=>0.003671940000000262, :count=>30, :avgskew=>0.00012239800000000874}
```

Skew isn't so bad here. Average skew per iteration is only 0.000122 seconds
(122 microseconds). After only 30 iterations, we're behind by 0.0037 seconds
(3.6ms). However, this is only over 30 iterations. What happens over thousands
of iterations? Lots of skew!

### Best? Implementation

Code: [interval3.rb](https://github.com/jordansissel/software-patterns/blob/master/interval-execution/ruby/examples/interval3.rb)

[interval3.rb] Ignores the runtime of the block and keeps incrementing the
target clock by the given interval based on the start time. This assures that
even if we do skew, we will correct for that skew, and execute at time T[0],
T[n], T[2n], etc.

```
% ruby run.rb 3
{:duration=>1.100340615, :skew=>0.0002219629999999917, :count=>1, :avgskew=>0.0002219629999999917}
{:duration=>0.99990078, :skew=>0.00015617599999995235, :count=>2, :avgskew=>7.808799999997618e-05}
{:duration=>0.999961995, :skew=>0.00015248100000020415, :count=>3, :avgskew=>5.082700000006805e-05}
{:duration=>0.999969992, :skew=>0.0001573309999995942, :count=>4, :avgskew=>3.933274999989855e-05}

...

{:duration=>0.999966158, :skew=>0.00014336899999989328, :count=>27, :avgskew=>5.30996296295901e-06}
{:duration=>0.999972856, :skew=>0.00015245199999824877, :count=>28, :avgskew=>5.444714285651742e-06}
{:duration=>0.999936856, :skew=>0.00012359400000150345, :count=>29, :avgskew=>4.26186206901736e-06}
{:duration=>0.99998492, :skew=>0.00014320100000020375, :count=>30, :avgskew=>4.773366666673458e-06}
```

This is the first example where the 'skew' value isn't always increasing. In
fact, it goes down sometimes. The total skew varies up and down around 0.00014
seconds.

While the skew is almost always around 130 microseconds, this may be the best
we can do with Ruby.
