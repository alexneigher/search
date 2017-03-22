# Cached Search

### - [See It Live](https://nameless-mesa-93376.herokuapp.com/)

### Running locally:


* `bundle install`
 
* `rake db:migrate`

* Make sure you have `redis` installed: `brew install redis`

* Make sure `redis` is running, `redis-server`

* `foreman start` (to run both the web/worker processes)

### Caching Strategy:

 * If a `product_search` exists matching `query` **AND** has a `cached_at` within 7 days
   * show that one
 * If a `product_search` exists matching `query` **BUT** has a `cached_at` *older than* 7 days
   * this one is expired
   * delete all associated `result` records
   * fetch and associate a new result set
   * update the `cached_at` date to `Date.current`

* If **NO** `product_search` exists for a `query`
   * create a new one and populate the results



**Pros**
* For frequently requested `query`'s we have a positive `cache_hit` every time (minus one every 7 days).
* Avoid a cache stampede, by avoiding a mass `cache_refresh` all at once.

**Cons**
* Infrequently requested `query` results may not have their cache busted often, or with any regularity (maybe this is okay?)
* We might be needlessly updating caches every 7 days if result sets do not change within that time interval. 


### Known Shortcomings

* Currently I call `destroy_all` during a re-saturation of `results` for a particular `product_search`
  * This produces a `DELETE FROM` query for *each* associated `result` record, which is an `n+1` situation :(
* Did not implement pagination, however, based on the docs for the `semantic3` gem, it appears as though one might pass through an `offset` parameter into the `get_products()` endpoint.