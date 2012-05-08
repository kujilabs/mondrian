# Mondrian

A ruby DSL based off of https://github.com/rsim/mondrian-olap.

This gem only consists of the schema definition and not the olap server
itself. It is not dependent on jruby. 

## Installation

Add this line to your application's Gemfile:

    gem 'mondrian'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mondrian

## Usage

### Schema definition

At first you need to define OLAP schema mapping to relational database schema tables and columns. OLAP schema consists of:

* Cubes

  Multidimensional cube is a collection of measures that can be accessed by dimensions. In relational database cubes are stored in fact tables with measure columns and dimension foreign key columns.

* Dimensions

  Dimension can be used in one cube (private) or in many cubes (shared). In relational database dimensions are stored in dimension tables.

* Hierarchies and levels

  Dimension has at least one primary hierarchy and optional additional hierarchies and each hierarchy has one or more levels. In relational database all levels can be stored in the same dimension table as different columns or can be stored also in several tables.

* Members

  Dimension hierarchy level values are called members.

* Measures

  Measures are values which can be accessed at detailed level or aggregated (e.g. as sum or average) at higher dimension hierarchy levels. In relational database measures are stored as columns in cube table.

* Calculated measures

  Calculated measures are not stored in database but calculated using specified formula from other measures.

Read more about about [defining Mondrian OLAP schema](http://mondrian.pentaho.com/documentation/schema.php).

Here is example how to define OLAP schema and its mapping to relational database tables and columns using mondrian-olap:

    require "rubygems"
    require "mondrian"

    schema = Mondrian::OLAP::Schema.define do
      cube 'Sales' do
        table 'sales'
        dimension 'Customers', :foreign_key => 'customer_id' do
          hierarchy :has_all => true, :all_member_name => 'All Customers', :primary_key => 'id' do
            table 'customers'
            level 'Country', :column => 'country', :unique_members => true
            level 'State Province', :column => 'state_province', :unique_members => true
            level 'City', :column => 'city', :unique_members => false
            level 'Name', :column => 'fullname', :unique_members => true
          end
        end
        dimension 'Products', :foreign_key => 'product_id' do
          hierarchy :has_all => true, :all_member_name => 'All Products',
                    :primary_key => 'id', :primary_key_table => 'products' do
            join :left_key => 'product_class_id', :right_key => 'id' do
              table 'products'
              table 'product_classes'
            end
            level 'Product Family', :table => 'product_classes', :column => 'product_family', :unique_members => true
            level 'Brand Name', :table => 'products', :column => 'brand_name', :unique_members => false
            level 'Product Name', :table => 'products', :column => 'product_name', :unique_members => true
          end
        end
        dimension 'Time', :foreign_key => 'time_id', :type => 'TimeDimension' do
          hierarchy :has_all => false, :primary_key => 'id' do
            table 'time'
            level 'Year', :column => 'the_year', :type => 'Numeric', :unique_members => true, :level_type => 'TimeYears'
            level 'Quarter', :column => 'quarter', :unique_members => false, :level_type => 'TimeQuarters'
            level 'Month', :column => 'month_of_year', :type => 'Numeric', :unique_members => false, :level_type => 'TimeMonths'
          end
          hierarchy 'Weekly', :has_all => false, :primary_key => 'id' do
            table 'time'
            level 'Year', :column => 'the_year', :type => 'Numeric', :unique_members => true, :level_type => 'TimeYears'
            level 'Week', :column => 'weak_of_year', :type => 'Numeric', :unique_members => false, :level_type => 'TimeWeeks'
          end
        end
        measure 'Unit Sales', :column => 'unit_sales', :aggregator => 'sum'
        measure 'Store Sales', :column => 'store_sales', :aggregator => 'sum'
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
