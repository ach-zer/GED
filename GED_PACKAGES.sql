--------------------------------------------------------
--  File created - Sunday-June-07-2020   
--------------------------------------------------------
DROP PACKAGE "HR"."DML_GED_ANN_DOC";
DROP PACKAGE "HR"."DML_GED_ANN_TYPE";
DROP PACKAGE "HR"."DML_GED_CARA";
DROP PACKAGE "HR"."DML_GED_CARA_DOC_BIN";
DROP PACKAGE "HR"."DML_GED_CLASSE_ARCH";
DROP PACKAGE "HR"."DML_GED_CLIENTS";
DROP PACKAGE "HR"."DML_GED_COMPAGNIES";
DROP PACKAGE "HR"."DML_GED_DOC_BIN";
DROP PACKAGE "HR"."DML_GED_FICHE_DOC_BIN";
DROP PACKAGE "HR"."DML_GED_REFE_DOC_BIN";
DROP PACKAGE "HR"."DML_GED_STRUCTURE_ARCH";
DROP PACKAGE "HR"."DML_GED_TYPE";
DROP PACKAGE "HR"."DML_GED_TYPE_DOC_BIN";
DROP PACKAGE "HR"."GED_CORE";
DROP PACKAGE "HR"."PLJSON_AC";
DROP PACKAGE "HR"."PLJSON_DYN";
DROP PACKAGE "HR"."PLJSON_EXT";
DROP PACKAGE "HR"."PLJSON_PARSER";
DROP PACKAGE "HR"."PLJSON_PRINTER";
DROP PACKAGE "HR"."WEB_PKG_LOGS";
DROP PACKAGE "HR"."WEB_PKG_ROUTER";
DROP PACKAGE "HR"."WEB_PKG_ROUTES";
--------------------------------------------------------
--  DDL for Type PLJSON
--------------------------------------------------------

  CREATE OR REPLACE TYPE "HR"."PLJSON" force under pljson_element (

  /*
  Copyright (c) 2010 Jonas Krogsboell

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  */

  /**
   * <p>This package defines <em>PL/JSON</em>'s representation of the JSON
   * object type, e.g.:</p>
   *
   * <pre>
   * {
   *   "foo": "bar",
   *   "baz": 42
   * }
   * </pre>
   *
   * <p>The primary method exported by this package is the <code>pljson</code>
   * method.</p>
   *
   * <strong>Example:</strong>
   * <pre>
   * declare
   *   myjson pljson := pljson('{ "foo": "foo", "bar": [0, 1, 2], "baz": { "foobar": "foobar" } }');
   * begin
   *   myjson.get('foo').print(); // => dbms_output.put_line('foo')
   *   myjson.get('bar[1]').print(); // => dbms_output.put_line('0')
   *   myjson.get('baz.foobar').print(); // => dbms_output.put_line('foobar')
   * end;
   * </pre>
   *
   * @headcom
   */

  /* Variables */
  /** Private variable for internal processing. */
  json_data pljson_value_array,
  /** Private variable for internal processing. */
  check_for_duplicate number,

  /* Constructors */

  /**
   * <p>Primary constructor that creates an empty object.</p>
   *
   * <p>Internally, a <code>pljson</code> "object" is an array of values.</p>
   *
   * <pre>
   *   decleare
   *     myjson pljson := pljson();
   *   begin
   *     myjson.put('foo', 'bar');
   *     dbms_output.put_line(myjson.get('foo')); // "bar"
   *   end;
   * </pre>
   *
   * @return A <code>pljson</code> instance.
   */
  constructor function pljson return self as result,

  /**
   * <p>Construct a <code>pljson</code> instance from a given string of JSON.</p>
   *
   * <pre>
   *   decleare
   *     myjson pljson := pljson('{"foo": "bar"}');
   *   begin
   *     dbms_output.put_line(myjson.get('foo')); // "bar"
   *   end;
   * </pre>
   *
   * @param str The JSON to parse into a <code>pljson</code> object.
   * @return A <code>pljson</code> instance.
   */
  constructor function pljson(str varchar2) return self as result,

  /**
   * <p>Construct a <code>pljson</code> instance from a given CLOB of JSON.</p>
   *
   * @param str The CLOB to parse into a <code>pljson</code> object.
   * @return A <code>pljson</code> instance.
   */
  constructor function pljson(str in clob) return self as result,

  /**
   * <p>Construct a <code>pljson</code> instance from a given BLOB of JSON.</p>
   *
   * @param str The BLOB to parse into a <code>pljson</code> object.
   * @param charset The character set of the BLOB data (defaults to UTF-8).
   * @return A <code>pljson</code> instance.
   */
  constructor function pljson(str in blob, charset varchar2 default 'UTF8') return self as result,

  /**
   * <p>Construct a <code>pljson</code> instance from
   * a given table of key,value pairs of type varchar2.</p>
   *
   * @param str_array The pljson_varray (table of varchar2) to parse into a <code>pljson</code> object.
   * @return A <code>pljson</code> instance.
   */
  constructor function pljson(str_array pljson_varray) return self as result,

  /**
   * <p>Create a new <code>pljson</code> object from a current <code>pljson_value</code>.
   *
   * <pre>
   *   declare
   *    myjson pljson := pljson('{"foo": {"bar": "baz"}}');
   *    newjson pljson;
   *   begin
   *    newjson := pljson(myjson.get('foo').to_json_value())
   *   end;
   * </pre>
   *
   * @param elem The <code>pljson_value</code> to cast to a <code>pljson</code> object.
   * @return An instance of <code>pljson</code>.
   */
  constructor function pljson(elem pljson_value) return self as result,

  /**
   * <p>Create a new <code>pljson</code> object from a current <code>pljson_list</code>.
   *
   * @param l The array to create a new object from.
   * @return An instance of <code>pljson</code>.
   */
  constructor function pljson(l in out nocopy pljson_list) return self as result,

  /* Member setter methods */
  /**
   * <p>Remove a key and value from an object.</p>
   *
   * <pre>
   *   declare
   *     myjson pljson := pljson('{"foo": "foo", "bar": "bar"}')
   *   begin
   *     myjson.remove('bar'); // => '{"foo": "foo"}'
   *   end;
   * </pre>
   *
   * @param pair_name The key name to remove.
   */
  member procedure remove(pair_name varchar2),

  /**
   * <p>Add a <code>pljson</code> instance into the current instance under a
   * given key name.</p>
   *
   * @param pair_name Name of the key to add/update.
   * @param pair_value The value to associate with the key.
   */
  member procedure put(self in out nocopy pljson, pair_name varchar2, pair_value pljson_value, position pls_integer default null),

  /**
   * <p>Add a <code>varchar2</code> instance into the current instance under a
   * given key name.</p>
   *
   * @param pair_name Name of the key to add/update.
   * @param pair_value The value to associate with the key.
   */
  member procedure put(self in out nocopy pljson, pair_name varchar2, pair_value varchar2, position pls_integer default null),

  /**
   * <p>Add a <code>number</code> instance into the current instance under a
   * given key name.</p>
   *
   * @param pair_name Name of the key to add/update.
   * @param pair_value The value to associate with the key.
   */
  member procedure put(self in out nocopy pljson, pair_name varchar2, pair_value number, position pls_integer default null),

  /* E.I.Sarmas (github.com/dsnz)   2016-12-01   support for binary_double numbers */
  /**
   * <p>Add a <code>binary_double</code> instance into the current instance under a
   * given key name.</p>
   *
   * @param pair_name Name of the key to add/update.
   * @param pair_value The value to associate with the key.
   */
  member procedure put(self in out nocopy pljson, pair_name varchar2, pair_value binary_double, position pls_integer default null),

  /**
   * <p>Add a <code>boolean</code> instance into the current instance under a
   * given key name.</p>
   *
   * @param pair_name Name of the key to add/update.
   * @param pair_value The value to associate with the key.
   */
  member procedure put(self in out nocopy pljson, pair_name varchar2, pair_value boolean, position pls_integer default null),

  member procedure check_duplicate(self in out nocopy pljson, v_set boolean),
  member procedure remove_duplicates(self in out nocopy pljson),

  /*
   * had been marked as deprecated in favor of the overloaded method with pljson_value
   * the reason is unknown even though it is useful in coding
   * and removes the need for the user to do a conversion
   * also path_put function has same overloaded parameter and is not marked as deprecated
   *
   * after tests by trying to add new overloaded procedures, a theory has emerged
   * with all procedures there are cyclic type references and installation is not possible
   * so some procedures had to be removed, and these were meant to be removed
   *
   * but by careful package ordering and removing only a few procedures from pljson_list package
   * it is possible to compile the project without error and keep these procedures
   */
  member procedure put(self in out nocopy pljson, pair_name varchar2, pair_value pljson, position pls_integer default null),
  /*
   * had been marked as deprecated in favor of the overloaded method with pljson_value
   * the reason is unknown even though it is useful in coding
   * and removes the need for the user to do a conversion
   * also path_put function has same overloaded parameter and is not marked as deprecated
   *
   * after tests by trying to add new overloaded procedures, a theory has emerged
   * with all procedures there are cyclic type references and installation is not possible
   * so some procedures had to be removed, and these were meant to be removed
   *
   * but by careful package ordering and removing only a few procedures from pljson_list package
   * it is possible to compile the project without error and keep these procedures
   */
  member procedure put(self in out nocopy pljson, pair_name varchar2, pair_value pljson_list, position pls_integer default null),

  /* Member getter methods */
  /**
   * <p>Return the number values in the object. Essentially, the number of keys
   * in the object.</p>
   *
   * @return The number of values in the object.
   */
  member function count return number,

  /**
   * <p>Retrieve the value of a given key.</p>
   *
   * @param pair_name The name of the value to retrieve.
   * @return An instance of <code>pljson_value</code>, or <code>null</code>
   * if it could not be found.
   */
  member function get(pair_name varchar2) return pljson_value,

  /**
   * <p>Retrieve a value based on its position in the internal storage array.
   * It is recommended you use name based retrieval.</p>
   *
   * @param position Index of the value in the internal storage array.
   * @return An instance of <code>pljson_value</code>, or <code>null</code>
   * if it could not be found.
   */
  member function get(position pls_integer) return pljson_value,

  /**
   * <p>Determine the position of a given value within the internal storage
   * array.</p>
   *
   * @param pair_name The name of the value to retrieve the index for.
   * @return An index number, or <code>-1</code> if it could not be found.
   */
  member function index_of(pair_name varchar2) return number,

  /**
   * <p>Determine if a given value exists within the object.</p>
   *
   * @param pair_name The name of the value to check for.
   * @return <code>true</code> if the value exists, <code>false</code> otherwise.
   */
  member function exist(pair_name varchar2) return boolean,

  /* Output methods */
  /**
   * <p>Serialize the object to a JSON representation string.</p>
   *
   * @param spaces Enable pretty printing by formatting with spaces. Default: <code>true</code>.
   * @param chars_per_line Wrap output to a specific number of characters per line. Default: <code>0<code> (infinite).
   * @return A <code>varchar2</code> string.
   */
  member function to_char(spaces boolean default true, chars_per_line number default 0) return varchar2,


    member function to_clob(self in pljson, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true) return clob,

  /**
   * <p>Serialize the object to a JSON representation and store it in a CLOB.</p>
   *
   * @param buf The CLOB in which to store the results.
   * @param spaces Enable pretty printing by formatting with spaces. Default: <code>false</code>.
   * @param chars_per_line Wrap output to a specific number of characters per line. Default: <code>0<code> (infinite).
   * @param erase_clob Whether or not to wipe the storage CLOB prior to serialization. Default: <code>true</code>.
   * @return A <code>varchar2</code> string.
   */

  member procedure to_clob(self in pljson, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true),

  /**
   * <p>Print a JSON representation of the object via <code>DBMS_OUTPUT</code>.</p>
   *
   * @param spaces Enable pretty printing by formatting with spaces. Default: <code>true</code>.
   * @param chars_per_line Wrap output to a specific number of characters per line. Default: <code>8192<code> (<code>32512</code> is maximum).
   * @param jsonp Name of a function for wrapping the output as JSONP. Default: <code>null</code>.
   * @return A <code>varchar2</code> string.
   */
  member procedure print(self in pljson, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null), --32512 is maximum

  /**
   * <p>Print a JSON representation of the object via <code>HTP.PRN</code>.</p>
   *
   * @param spaces Enable pretty printing by formatting with spaces. Default: <code>true</code>.
   * @param chars_per_line Wrap output to a specific number of characters per line. Default: <code>0<code> (infinite).
   * @param jsonp Name of a function for wrapping the output as JSONP. Default: <code>null</code>.
   * @return A <code>varchar2</code> string.
   */
  member procedure htp(self in pljson, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null),

  /**
   * <p>Convert the object to a <code>pljson_value</code> for use in other methods
   * of the PL/JSON API.</p>
   *
   * @returns An instance of <code>pljson_value</code>.
   */
  member function to_json_value return pljson_value,

  /* json path */
  /**
   * <p>Retrieve a value from the internal storage array based on a path string
   * and a starting index.</p>
   *
   * @param json_path A string path, e.g. <code>'foo.bar[1]'</code>.
   * @param base The index in the internal storage array to start from.
   * This should only be necessary under special circumstances. Default: <code>1</code>.
   * @return An instance of <code>pljson_value</code>.
   */
  member function path(json_path varchar2, base number default 1) return pljson_value,

  /* json path_put */
  member procedure path_put(self in out nocopy pljson, json_path varchar2, elem pljson_value, base number default 1),
  member procedure path_put(self in out nocopy pljson, json_path varchar2, elem varchar2, base number default 1),
  member procedure path_put(self in out nocopy pljson, json_path varchar2, elem number, base number default 1),
  /* E.I.Sarmas (github.com/dsnz)   2016-12-01   support for binary_double numbers */
  member procedure path_put(self in out nocopy pljson, json_path varchar2, elem binary_double, base number default 1),
  member procedure path_put(self in out nocopy pljson, json_path varchar2, elem boolean, base number default 1),
  member procedure path_put(self in out nocopy pljson, json_path varchar2, elem pljson_list, base number default 1),
  member procedure path_put(self in out nocopy pljson, json_path varchar2, elem pljson, base number default 1),

  /* json path_remove */
  member procedure path_remove(self in out nocopy pljson, json_path varchar2, base number default 1),

  /* map functions */
  /**
   * <p>Retrieve all of the values within the object as a <code>pljson_list</code>.</p>
   *
   * <pre>
   * myjson := pljson('{"foo": "bar"}');
   * myjson.get_values(); // ['bar']
   * </pre>
   *
   * @return An instance of <code>pljson_list</code>.
   */
  member function get_values return pljson_list,

  /**
   * <p>Retrieve all of the keys within the object as a <code>pljson_list</code>.</p>
   *
   * <pre>
   * myjson := pljson('{"foo": "bar"}');
   * myjson.get_keys(); // ['foo']
   * </pre>
   *
   * @return An instance of <code>pljson_list</code>.
   */
  member function get_keys return pljson_list

) not final;
/
CREATE OR REPLACE TYPE BODY "HR"."PLJSON" wrapped
a000000
b2
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
e
3338 9ee
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

/

  GRANT EXECUTE ON "HR"."PLJSON" TO PUBLIC;
--------------------------------------------------------
--  DDL for Type PLJSON_ELEMENT
--------------------------------------------------------

  CREATE OR REPLACE TYPE "HR"."PLJSON_ELEMENT" force as object
(
  obj_type number
)
not final;

/

  GRANT EXECUTE ON "HR"."PLJSON_ELEMENT" TO PUBLIC;
--------------------------------------------------------
--  DDL for Type PLJSON_VALUE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "HR"."PLJSON_VALUE" force as object (

  /*
  Copyright (c) 2010 Jonas Krogsboell

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  */

  /**
   * <p>Underlying type for all of <em>PL/JSON</em>. Each <code>pljson</code>
   * or <code>pljson_list</code> object is composed of
   * <code>pljson_value</code> objects.</p>
   *
   * <p>Generally, you should not need to directly use the constructors provided
   * by this portion of the API. The methods on <code>pljson</code> and
   * <code>pljson_list</code> should be used instead.</p>
   *
   * @headcom
   */

  /**
   * <p>Internal property that indicates the JSON type represented:<p>
   * <ol>
   *   <li><code>object</code></li>
   *   <li><code>array</code></li>
   *   <li><code>string</code></li>
   *   <li><code>number</code></li>
   *   <li><code>bool</code></li>
   *   <li><code>null</code></li>
   * </ol>
   */
  typeval number(1), /* 1 = object, 2 = array, 3 = string, 4 = number, 5 = bool, 6 = null */
  /** Private variable for internal processing. */
  str varchar2(32767),
  /** Private variable for internal processing. */
  num number, /* store 1 as true, 0 as false */
  /** Private variable for internal processing. */
  num_double binary_double, -- both num and num_double are set, there is never exception (until Oracle 12c)
  /** Private variable for internal processing. */
  num_repr_number_p varchar2(1),
  /** Private variable for internal processing. */
  num_repr_double_p varchar2(1),
  /** Private variable for internal processing. */
  object_or_array pljson_element, /* object or array in here */
  /** Private variable for internal processing. */
  extended_str clob,

  /* mapping */
  /** Private variable for internal processing. */
  mapname varchar2(4000),
  /** Private variable for internal processing. */
  mapindx number(32),

  constructor function pljson_value(elem pljson_element) return self as result,
  constructor function pljson_value(str varchar2, esc boolean default true) return self as result,
  constructor function pljson_value(str clob, esc boolean default true) return self as result,
  constructor function pljson_value(num number) return self as result,
  /* E.I.Sarmas (github.com/dsnz)   2016-11-03   support for binary_double numbers */
  constructor function pljson_value(num_double binary_double) return self as result,
  constructor function pljson_value(b boolean) return self as result,
  constructor function pljson_value return self as result,

  member function get_element return pljson_element,

  /**
   * <p>Create an empty <code>pljson_value</code>.</p>
   *
   * <pre>
   * declare
   *   myval pljson_value := pljson_value.makenull();
   * begin
   *   myval.parse_number('42');
   *   myval.print(); // => dbms_output.put_line('42');
   * end;
   * </pre>
   *
   * @return An instance of <code>pljson_value</code>.
   */
  static function makenull return pljson_value,

  /**
   * <p>Retrieve the name of the type represented by the <code>pljson_value</code>.</p>
   * <p>Possible return values:</p>
   * <ul>
   *   <li><code>object</code></li>
   *   <li><code>array</code></li>
   *   <li><code>string</code></li>
   *   <li><code>number</code></li>
   *   <li><code>bool</code></li>
   *   <li><code>null</code></li>
   * </ul>
   *
   * @return The name of the type represented.
   */
  member function get_type return varchar2,

  /**
   * <p>Retrieve the value as a string (<code>varchar2</code>).</p>
   *
   * @param max_byte_size Retreive the value up to a specific number of bytes. Default: <code>null</code>.
   * @param max_char_size Retrieve the value up to a specific number of characters. Default: <code>null</code>.
   * @return An instance of <code>varchar2</code> or <code>null</code> value is not a string.
   */
  member function get_string(max_byte_size number default null, max_char_size number default null) return varchar2,

  /**
   * <p>Retrieve the value as a string represented by a <code>CLOB</code>.</p>
   *
   * @param buf The <code>CLOB</code> in which to store the string.
   */
  member procedure get_string(self in pljson_value, buf in out nocopy clob),

  /**
   * <p>Retrieve the value as a <code>number</code>.</p>
   *
   * @return An instance of <code>number</code> or <code>null</code> if the value isn't a number.
   */
  member function get_number return number,

  /* E.I.Sarmas (github.com/dsnz)   2016-11-03   support for binary_double numbers */
  /**
   * <p>Retrieve the value as a <code>binary_double</code>.</p>
   *
   * @return An instance of <code>binary_double</code> or <code>null</code> if the value isn't a number.
   */
  member function get_double return binary_double,

  /**
   * <p>Retrieve the value as a <code>boolean</code>.</p>
   *
   * @return An instance of <code>boolean</code> or <code>null</code> if the value isn't a boolean.
   */
  member function get_bool return boolean,

  /**
   * <p>Retrieve the value as a string <code>'null'<code>.</p>
   *
   * @return A <code>varchar2</code> with the value <code>'null'</code> or
   * an actual <code>null</code> if the value isn't a JSON "null".
   */
  member function get_null return varchar2,

  /**
   * <p>Determine if the value represents an "object" type.</p>
   *
   * @return <code>true</code> if the value is an object, <code>false</code> otherwise.
   */
  member function is_object return boolean,

  /**
   * <p>Determine if the value represents an "array" type.</p>
   *
   * @return <code>true</code> if the value is an array, <code>false</code> otherwise.
   */
  member function is_array return boolean,

  /**
   * <p>Determine if the value represents a "string" type.</p>
   *
   * @return <code>true</code> if the value is a string, <code>false</code> otherwise.
   */
  member function is_string return boolean,

  /**
   * <p>Determine if the value represents a "number" type.</p>
   *
   * @return <code>true</code> if the value is a number, <code>false</code> otherwise.
   */
  member function is_number return boolean,

  /**
   * <p>Determine if the value represents a "boolean" type.</p>
   *
   * @return <code>true</code> if the value is a boolean, <code>false</code> otherwise.
   */
  member function is_bool return boolean,

  /**
   * <p>Determine if the value represents a "null" type.</p>
   *
   * @return <code>true</code> if the value is a null, <code>false</code> otherwise.
   */
  member function is_null return boolean,

  /* E.I.Sarmas (github.com/dsnz)   2016-11-03   support for binary_double numbers, is_number is still true, extra info */
  /* return true if 'number' is representable by number */
  /** Private method for internal processing. */
  member function is_number_repr_number return boolean,
  /* return true if 'number' is representable by binary_double */
  /** Private method for internal processing. */
  member function is_number_repr_double return boolean,

  /* E.I.Sarmas (github.com/dsnz)   2016-11-03   support for binary_double numbers */
  -- set value for number from string representation; to replace to_number in pljson_parser
  -- can automatically decide and use binary_double if needed
  -- less confusing than new constructor with dummy argument for overloading
  -- centralized parse_number to use everywhere else and replace code in pljson_parser
  /**
   * <p>Parses a string into a number. This method will automatically cast to
   * a <code>binary_double</code> if it is necessary.</p>
   *
   * <pre>
   * declare
   *   mynum pljson_value := pljson_value('42');
   * begin
   *   dbms_output.put_line('mynum is a string: ' || mynum.is_string()); // 'true'
   *   mynum.parse_number('42');
   *   dbms_output.put_line('mynum is a number: ' || mynum.is_number()); // 'true'
   * end;
   * </pre>
   *
   * @param str A <code>varchar2</code> to parse into a number.
   */
  -- this procedure is meant to be used internally only
  -- procedure does not work correctly if called standalone in locales that
  -- use a character other than "." for decimal point
  member procedure parse_number(str varchar2),

  /* E.I.Sarmas (github.com/dsnz)   2016-12-01   support for binary_double numbers */
  /**
   * <p>Return a <code>varchar2</code> representation of a <code>number</code>
   * type. This is primarily intended to be used within PL/JSON internally.</p>
   *
   * @return A <code>varchar2</code> up to 4000 characters.
   */
  -- this procedure is meant to be used internally only
  member function number_toString return varchar2,

  /* Output methods */
  member function to_char(spaces boolean default true, chars_per_line number default 0) return varchar2,
  member procedure to_clob(self in pljson_value, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true),
  member procedure print(self in pljson_value, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null), --32512 is maximum
  member procedure htp(self in pljson_value, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null),

  member function value_of(self in pljson_value, max_byte_size number default null, max_char_size number default null) return varchar2

) not final;
/
CREATE OR REPLACE TYPE BODY "HR"."PLJSON_VALUE" wrapped
a000000
b2
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
e
2497 9ba
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
5Ft/3fkU

/

  GRANT EXECUTE ON "HR"."PLJSON_VALUE" TO PUBLIC;
--------------------------------------------------------
--  DDL for Type PLJSON_VALUE_ARRAY
--------------------------------------------------------

  CREATE OR REPLACE TYPE "HR"."PLJSON_VALUE_ARRAY" as table of pljson_value;

/

  GRANT EXECUTE ON "HR"."PLJSON_VALUE_ARRAY" TO PUBLIC;
--------------------------------------------------------
--  DDL for Type PLJSON_LIST
--------------------------------------------------------

  CREATE OR REPLACE TYPE "HR"."PLJSON_LIST" force under pljson_element (

  /*
  Copyright (c) 2010 Jonas Krogsboell

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  */

  /**
   * <p>This package defines <em>PL/JSON</em>'s representation of the JSON
   * array type, e.g. <code>[1, 2, "foo", "bar"]</code>.</p>
   *
   * <p>The primary method exported by this package is the <code>pljson_list</code>
   * method.</p>
   *
   * <strong>Example:</strong>
   *
   * <pre>
   * declare
   *   myarr pljson_list := pljson_list('[1, 2, "foo", "bar"]');
   * begin
   *   myarr.get(1).print(); // => dbms_output.put_line(1)
   *   myarr.get(3).print(); // => dbms_output.put_line('foo')
   * end;
   * </pre>
   *
   * @headcom
   */

  /** Private variable for internal processing. */
  list_data pljson_value_array,

  /**
   * <p>Create an empty list.</p>
   *
   * <pre>
   * declare
   *   myarr pljson_list := pljson_list();
   * begin
   *   dbms_output.put_line(myarr.count()); // => 0
   * end;
   *
   * @return An instance of <code>pljson_list</code>.
   */
  constructor function pljson_list return self as result,

  /**
   * <p>Create an instance from a given JSON array representation.</p>
   *
   * <pre>
   * declare
   *   myarr pljson_list := pljson_list('[1, 2, "foo", "bar"]');
   * begin
   *   myarr.get(1).print(); // => dbms_output.put_line(1)
   *   myarr.get(3).print(); // => dbms_output.put_line('foo')
   * end;
   * </pre>
   *
   * @param str The JSON array string to parse.
   * @return An instance of <code>pljson_list</code>.
   */
  constructor function pljson_list(str varchar2) return self as result,

  /**
   * <p>Create an instance from a given JSON array representation stored in
   * a <code>CLOB</code>.</p>
   *
   * @param str The <code>CLOB</code> to parse.
   * @return An instance of <code>pljson_list</code>.
   */
  constructor function pljson_list(str clob) return self as result,

  /**
   * <p>Create an instance from a given JSON array representation stored in
   * a <code>BLOB</code>.</p>
   *
   * @param str The <code>BLOB</code> to parse.
   * @param charset The character set of the BLOB data (defaults to UTF-8).
   * @return An instance of <code>pljson_list</code>.
   */
  constructor function pljson_list(str blob, charset varchar2 default 'UTF8') return self as result,

  /**
   * <p>Create an instance instance from a given table of string values of type varchar2.</p>
   *
   * @param str_array The pljson_varray (table of varchar2) of string values.
   * @return An instance of <code>pljson_list</code>.
   */
  constructor function pljson_list(str_array pljson_varray) return self as result,

  /**
   * <p>Create an instance instance from a given table of string values of type varchar2.</p>
   *
   * @param str_array The pljson_varray (table of varchar2) of string values.
   * @return An instance of <code>pljson_list</code>.
   */
  constructor function pljson_list(num_array pljson_narray) return self as result,

  /**
   * <p>Create an instance from a given instance of <code>pljson_value</code>
   * that represents an array.</p>
   *
   * @param elem The <code>pljson_value</code> to cast to a <code>pljson_list</code>.
   * @return An instance of <code>pljson_list</code>.
   */
  constructor function pljson_list(elem pljson_value) return self as result,

  member procedure append(self in out nocopy pljson_list, elem pljson_value, position pls_integer default null),
  member procedure append(self in out nocopy pljson_list, elem varchar2, position pls_integer default null),
  member procedure append(self in out nocopy pljson_list, elem number, position pls_integer default null),
  /* E.I.Sarmas (github.com/dsnz)   2016-12-01   support for binary_double numbers */
  member procedure append(self in out nocopy pljson_list, elem binary_double, position pls_integer default null),
  member procedure append(self in out nocopy pljson_list, elem boolean, position pls_integer default null),
  member procedure append(self in out nocopy pljson_list, elem pljson_list, position pls_integer default null),

  member procedure replace(self in out nocopy pljson_list, position pls_integer, elem pljson_value),
  member procedure replace(self in out nocopy pljson_list, position pls_integer, elem varchar2),
  member procedure replace(self in out nocopy pljson_list, position pls_integer, elem number),
  /* E.I.Sarmas (github.com/dsnz)   2016-12-01   support for binary_double numbers */
  member procedure replace(self in out nocopy pljson_list, position pls_integer, elem binary_double),
  member procedure replace(self in out nocopy pljson_list, position pls_integer, elem boolean),
  member procedure replace(self in out nocopy pljson_list, position pls_integer, elem pljson_list),

  member function count return number,
  member procedure remove(self in out nocopy pljson_list, position pls_integer),
  member procedure remove_first(self in out nocopy pljson_list),
  member procedure remove_last(self in out nocopy pljson_list),
  member function get(position pls_integer) return pljson_value,
  member function head return pljson_value,
  member function last return pljson_value,
  member function tail return pljson_list,

  /* Output methods */
  member function to_char(spaces boolean default true, chars_per_line number default 0) return varchar2,
  member function to_clob(self in pljson_list, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true) return clob,
  member procedure to_clob(self in pljson_list, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true),
  member procedure print(self in pljson_list, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null), --32512 is maximum
  member procedure htp(self in pljson_list, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null),

  /* json path */
  member function path(json_path varchar2, base number default 1) return pljson_value,
  /* json path_put */
  member procedure path_put(self in out nocopy pljson_list, json_path varchar2, elem pljson_value, base number default 1),
  member procedure path_put(self in out nocopy pljson_list, json_path varchar2, elem varchar2, base number default 1),
  member procedure path_put(self in out nocopy pljson_list, json_path varchar2, elem number, base number default 1),
  /* E.I.Sarmas (github.com/dsnz)   2016-12-01   support for binary_double numbers */
  member procedure path_put(self in out nocopy pljson_list, json_path varchar2, elem binary_double, base number default 1),
  member procedure path_put(self in out nocopy pljson_list, json_path varchar2, elem boolean, base number default 1),
  member procedure path_put(self in out nocopy pljson_list, json_path varchar2, elem pljson_list, base number default 1),

  /* json path_remove */
  member procedure path_remove(self in out nocopy pljson_list, json_path varchar2, base number default 1),

  member function to_json_value return pljson_value
  /* --backwards compatibility
  member procedure add_elem(self in out nocopy json_list, elem json_value, position pls_integer default null),
  member procedure add_elem(self in out nocopy json_list, elem varchar2, position pls_integer default null),
  member procedure add_elem(self in out nocopy json_list, elem number, position pls_integer default null),
  member procedure add_elem(self in out nocopy json_list, elem boolean, position pls_integer default null),
  member procedure add_elem(self in out nocopy json_list, elem json_list, position pls_integer default null),

  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem json_value),
  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem varchar2),
  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem number),
  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem boolean),
  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem json_list),

  member procedure remove_elem(self in out nocopy json_list, position pls_integer),
  member function get_elem(position pls_integer) return json_value,
  member function get_first return json_value,
  member function get_last return json_value
--*/

) not final;
/
CREATE OR REPLACE TYPE BODY "HR"."PLJSON_LIST" wrapped
a000000
b2
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
e
3086 861
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
aEZeEq63p20mfPiqBj2WtR3X3xzc

/

  GRANT EXECUTE ON "HR"."PLJSON_LIST" TO PUBLIC;
--------------------------------------------------------
--  DDL for Package DML_GED_ANN_DOC
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."DML_GED_ANN_DOC" IS
    PROCEDURE ins_ged_ann_doc (
        v_params       IN pljson,
        v_err          OUT VARCHAR2,
        v_res          OUT pljson
    );

    PROCEDURE sel_ged_ann_doc_id (
        v_params           IN pljson,
        v_err              OUT VARCHAR2,
        v_res              OUT pljson
    );

  -- No Primary Key!  Cannot create UPDATE procedure for GED_ANN_DOC using primary key. 

  -- No Primary Key!  Cannot create DELETE procedure for GED_ANN_DOC using primary key. 

END dml_ged_ann_doc;

/
--------------------------------------------------------
--  DDL for Package DML_GED_ANN_TYPE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."DML_GED_ANN_TYPE" AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */
    PROCEDURE sel_ged_ann_type (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );

END dml_ged_ann_type;

/
--------------------------------------------------------
--  DDL for Package DML_GED_CARA
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."DML_GED_CARA" AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
    PROCEDURE select_caracs_chosen_type (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );

END DML_GED_CARA;

/
--------------------------------------------------------
--  DDL for Package DML_GED_CARA_DOC_BIN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."DML_GED_CARA_DOC_BIN" IS
    PROCEDURE ins_ged_cara_doc_bin (
        v_params      IN pljson,
        v_err         OUT VARCHAR2,
        v_res         OUT pljson
    );
    
  -- No Primary Key!  Cannot create UPDATE procedure for GED_CARA_DOC_BIN using primary key. 

  -- No Primary Key!  Cannot create DELETE procedure for GED_CARA_DOC_BIN using primary key. 

END dml_ged_cara_doc_bin;

/
--------------------------------------------------------
--  DDL for Package DML_GED_CLASSE_ARCH
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."DML_GED_CLASSE_ARCH" AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */
    PROCEDURE create_classe_arch (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );
    
    PROCEDURE delete_classe_arch (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );
    PROCEDURE select_classes_archive (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );

END dml_ged_classe_arch;

/
--------------------------------------------------------
--  DDL for Package DML_GED_CLIENTS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."DML_GED_CLIENTS" AS
    PROCEDURE ins_ged_clients (
        v_params    IN pljson,
        v_err       OUT VARCHAR2,
        v_res       OUT pljson
    );
    PROCEDURE select_fields_clients (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );

END dml_ged_clients;

/
--------------------------------------------------------
--  DDL for Package DML_GED_COMPAGNIES
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."DML_GED_COMPAGNIES" AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */
    PROCEDURE ins_ged_compagnies (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );

END dml_ged_compagnies;

/
--------------------------------------------------------
--  DDL for Package DML_GED_DOC_BIN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."DML_GED_DOC_BIN" IS
    PROCEDURE ins_ged_doc_bin (
        in_lobdocbi    IN BLOB,
        out_idedocbi   OUT NUMBER
    );

    PROCEDURE identify_ged_doc_bin (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );

    PROCEDURE upd_ged_doc_bin (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );

    PROCEDURE del_ged_doc_bin (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );

    PROCEDURE sel_ged_docs_bin_ids (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );
    PROCEDURE sel_blob_doc_bin_by_id (
        in_idedocbi IN NUMBER,
        out_lobdocbi OUT BLOB
    );
    PROCEDURE sel_blob_doc_bin_by_keyword (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );
    PROCEDURE sel_ged_doc_bin_non_type (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );
    PROCEDURE sel_ged_doc_bin_non_classe (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );

END dml_ged_doc_bin;

/
--------------------------------------------------------
--  DDL for Package DML_GED_FICHE_DOC_BIN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."DML_GED_FICHE_DOC_BIN" IS
    PROCEDURE ins_ged_fiche_doc_bin (
        v_params      IN pljson,
        v_err         OUT VARCHAR2,
        v_res         OUT pljson
    );

    PROCEDURE upd_ged_fiche_doc_bin (
        v_params      IN pljson,
        v_err         OUT VARCHAR2,
        v_res         OUT pljson
    );

    PROCEDURE del_ged_fiche_doc_bin (
        v_params      IN pljson,
        v_err         OUT VARCHAR2,
        v_res         OUT pljson
    );

    PROCEDURE upd_datetypa_ged_fiche_doc_bin (
        v_params      IN pljson,
        v_err         OUT VARCHAR2,
        v_res         OUT pljson
    );

    PROCEDURE upd_class_ged_fiche_doc_bin (
        v_params      IN pljson,
        v_err         OUT VARCHAR2,
        v_res         OUT pljson
    );

END dml_ged_fiche_doc_bin;

/
--------------------------------------------------------
--  DDL for Package DML_GED_REFE_DOC_BIN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."DML_GED_REFE_DOC_BIN" IS
    PROCEDURE ins_ged_refe_doc_bin (
        v_params      IN pljson,
        v_err         OUT VARCHAR2,
        v_res         OUT pljson
    );

  -- No Primary Key!  Cannot create UPDATE procedure for GED_REFE_DOC_BIN using primary key. 

  -- No Primary Key!  Cannot create DELETE procedure for GED_REFE_DOC_BIN using primary key. 

END dml_ged_refe_doc_bin;

/
--------------------------------------------------------
--  DDL for Package DML_GED_STRUCTURE_ARCH
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."DML_GED_STRUCTURE_ARCH" AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
  PROCEDURE sel_structure_archive (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );
    PROCEDURE sel_structure_archive_ids (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );
    PROCEDURE classer_document(
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );
    PROCEDURE create_structure_arch (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );

END DML_GED_STRUCTURE_ARCH;

/
--------------------------------------------------------
--  DDL for Package DML_GED_TYPE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."DML_GED_TYPE" AS
    PROCEDURE SELECT_ALL_TYPES (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    );
  /* TODO enter package declarations (types, exceptions, methods etc) here */

END dml_ged_type;

/
--------------------------------------------------------
--  DDL for Package DML_GED_TYPE_DOC_BIN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."DML_GED_TYPE_DOC_BIN" IS
    PROCEDURE ins_ged_type_doc_bin (
        v_params      IN pljson,
        v_err         OUT VARCHAR2,
        v_res         OUT pljson
    );

    PROCEDURE upd_ged_type_doc_bin (
        v_params      IN pljson,
        v_err         OUT VARCHAR2,
        v_res         OUT pljson
    );

    PROCEDURE del_ged_type_doc_bin (
        v_params      IN pljson,
        v_err         OUT VARCHAR2,
        v_res         OUT pljson
    );

END dml_ged_type_doc_bin;

/
--------------------------------------------------------
--  DDL for Package GED_CORE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."GED_CORE" as
    procedure test(v_params in pljson, v_err out varchar2, v_res out pljson);
end;

/

  GRANT EXECUTE, DEBUG ON "HR"."GED_CORE" TO PUBLIC;
--------------------------------------------------------
--  DDL for Package PLJSON_AC
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."PLJSON_AC" wrapped
a000000
b2
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
9
2133 4f9
oy7ROQh4KAOfzF8h4R+T78GtNZgwg9eT2UrrfI4BAA/ubO/XrDhE/JehSAVHU2EB2j2J8AK0
qDZa5J1G63qjJR60Urdv3t+gM63+zRIYGjrVVaY6c4b4Tw8kzbEgRvxb5uwkJqLL6WOp44pE
wAuUitscGQwKNzuh+vRNdO5mH5tnFBKzrCTzoQwBrVX7MV6NICaSzlMVS5EB6OENT80+Cg4A
PORqEKj13vKvVcaDp2jdOY4+cC7Vi6nV1Kd/Bopq+ATdCkw5xac/vZnC8V4ySwJNZZ+dopHm
fA56WCSa5vknbfLCZbAbaQYS/mMpFlI06F7cqSN0Ui1o0sa5t4lh6ZMm10aeTOp6JByKCe/F
P0iA/YJR3cMYxKRL5tFIj5ure097TU73ZfsvUlarwl1ENJMtQclNmhcwx69BOTw8LUmSYLSS
V+EmbNc1v7H4w6tccoaSSmHTidkiu9TDqouErhmT1jwP19eiQLgXPUsUHtaHEzyJKUvMrjaO
PbhdolWb9fTFvlh4Ik9BJJjc5TiRLGvjP1WriCCAflnmK48qx+UjqsFAI4QJA+nkrYflndr9
e1jZBVAzF5bz7OlbBBwwBHh8tLJh82huPeE0EIeFYpO602X/RaYIcDFTkMZM/mjf/xcofaQw
vaH/uF9p47sLcnVSclLruHtXC/znI4f1+J4HMKlr68M+I0vD8o+VdZjN00ZHGCaYk54LRVmh
OJjmtxpQTD5n8RZePdSUQ2VSbRzAxchHzfvzGgRECb5NFwNLMD94dfdrJlDphIGuXNHBvdHm
wa5CELngy3ghUyL2SHGepwzvhJaV4/DQP6KY0Y3fNWh/NmAL+znzr/UGdR+vAlM3VeFi4VLL
ynR68md8oJFS5xeWiy9q7z4FL2JN1a7kddh+OrWZeTFUGAzZHoYhXA9hgQeF2VK6p1B1eZF8
ebSrx+1nNIWE23sA5kFNL8GGQeXTwQvcaRhO90lNlYj6ScXUMdViTasQ0rOuwEWsHlsIhbui
hrslOg8o+MIkxXvHyOdxAw3gKNulvN9IuUh6566RgJp+n3xwMjpDFbEjySqAJzC7992ElBfn
+QkA4NEqG0aswKPrL+Po8OYvtdJ2yaFVHzXI664lnEp832zEHeMJBWCSSeyPuSz2eHOSEdzv
ucYBJaq1GM4sMTGJBR2mu4uxb9KsCg/ZSrkQjM31hpVyMSkxkuLQs3cNcjGsuc+Gp1Yt0q0M
Shq0tYlieqcsHKkfpJTX6rv54a3VmzQ=

/

  GRANT EXECUTE ON "HR"."PLJSON_AC" TO PUBLIC;
--------------------------------------------------------
--  DDL for Package PLJSON_DYN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."PLJSON_DYN" wrapped
a000000
b2
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
9
2de 179
fBIsTUXooF0qLy2Eb+PsgonCT74wgw3xLdwdf3RAWLs+eqx39Pe21pYIDT6tsMKkdxPCfKjD
yHUwEiXhPVysM280kwj+BfmQskVbcdM07XqdnbmX68bLfAXFMLiTRrTyK9NneQ46KqZXxlRp
mbL9/W3sNofhZ5wJFJGPkQfTU5hbt1liZwLhmHUAlNBgnsZ1W751Ra1QNinR7wBgADhpNoCQ
KrrHdWRyilYUOYPx2WB/TUwKsjnQFkgCwJip0UtkiH4Go/ZjsBzH5NNxigCWbgfsskwyEJIw
HeanAp2vwrFItX0TRSq+tfxoHEo/m0TsA5hbQImy9Xdmd7Fg7F1NrTFD5BwfXOVnhIqq5Ajv
xOpPx9sNJw==

/

  GRANT EXECUTE ON "HR"."PLJSON_DYN" TO PUBLIC;
--------------------------------------------------------
--  DDL for Package PLJSON_EXT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."PLJSON_EXT" wrapped
a000000
b2
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
9
b3f 316
h4aIdpaQq6iexW/QdUpxn1597d0wgw0rLtDrfC9DaA9/xMljWpk4Amnvy0qCeQMaYUNX8xKX
Afdvovsmdo+atgX63/8Xv4ySaS4nnf56QQhfRGtP+svu/tC7sA8k2WSqtab6K6YKr+7kZCSm
Ya2Mxe50NveInlEzGRDUkyZiFuMaEmYdLGbxqEvkL2tGBMQUrpQ0mPv0xZyU3yp1IfrDEeO6
NNrDY1hiWuyMxoz4I74olQrDdK60jYWJWbT/a7vIBX9is9i5s7rbCSPas+/QQhxjU4l68gT3
KCqTV46sQkRTFjbWXRuSgp6WhVFK5ttCRc/47ET0MbVnp6NUWL0aXgmcAS9GaZo2qK2VV5zn
ZsRbiXyPvuHUPh8oC2V1Bq9SuFR4cU1wvXP0arrlj11jqmz3ycvifVrVJHMKpKfXabX8h3XF
exyygKIGNx8wvv82JutS28N4BNj6YsawrzjBi/TAZMnzkHNsk1h8ApjluR//LYEe9EBSQsou
LCPogRmdRHlo3Yu22CwsINDGBao9qbCwj0jH5GGtkDxrjXmG2UJAqzwZSwbN3P2EWY5Kn3JK
sCPN2BMAvj6JQf03NpavdcsmModMt/08bLFgx1kXYU7s5mBCXyM6B5gWQ8xnCiyuiYM85Q7w
wbL8+ktCkA1U4HoDfSo1kZOgeWfBL4hA3zxReroQClW26sDYMTxLoO1w5pWSrbAlqsKTcmC2
4rOTvgJ9z/H3LRAOGz93gxJzRlzBb2iiEZAKzcYNy7bCU8zblsXPTixVyrEi

/

  GRANT EXECUTE ON "HR"."PLJSON_EXT" TO PUBLIC;
--------------------------------------------------------
--  DDL for Package PLJSON_PARSER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."PLJSON_PARSER" wrapped
a000000
b2
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
9
532 288
538GNff4b9PcLNZOvwyq6BgfXQAwg42JLtDrfC9Arf7qR7ONxRQY2/KidnYXCSUyADy00c36
Bt1EqFTN+aq9BS4lQMkd0okw5LxOR4ALYyOJ2kawLJoPP3Nfrg9PD7wA1vXVqT2KlpCcL6kk
ujYz0uM5e1tfGFP792acVCGbqbiJ2CIMGRgHgehG9Rcv2J8tghy/hZxe6ZL5S/eHh7IZICwi
dBut0ynjaCeS4fJe7eJwRiVElwHFlvbwZ83nJ6t6NRC8LiuyRe3vtqQKBcD101i4TbZewt6k
kggqmuS3y3FHIQAJG0V1I7mJB+xajFlAiUygQNBPDo2DOL4xOYzPgD5fSSwDO1pTsPa8oiiO
8YmOMU7jmNxLIkuIOOWTA82dvnlnHBZ1a1kRS401EjDEbtTyn1qBh9LtuxdLN/H17Pzo/owm
PYhwg1vZdX5//gl3a9fRY2ReLlYmOs1pZyoLf0omxIgZtcbyhr2Titk/VnJrZAAKYrcVG7ij
QtxsxtPzvA/G2UBftdjegpMaO0Lw0rz+zL//lqGXAoiQIcHpMcz8qT3VMIJOVOYT/ZoPS4sU
7yUN7V8H0gDjLktFXiWMtt6IuzPRCrG3kdrSfxCAcT+8BbuU7MlFqz0TmmlBK2Q=

/

  GRANT EXECUTE ON "HR"."PLJSON_PARSER" TO PUBLIC;
--------------------------------------------------------
--  DDL for Package PLJSON_PRINTER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."PLJSON_PRINTER" wrapped
a000000
b2
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
9
56b 227
Lx8/x1Uba+GSTg6kVCWMcu45KjMwg+3D164VfI7+Rw8ISH69W90TbQfiEguV4nmSNzEmSSir
1jYAm8YFMnxp+7ZRVi486J1kNLwr85JnyecKsZz+xGMPO0+cLK72ysmmfM4I+3zMDksZVNfb
dG+i6xh93mWIhNqh7rkcQKZqdOErj+8X4RCYAwfcxFoRLaAl+l3fVX4GkW5gh3jja19CKdjA
b8A+rdPzWsoaRO5XICkr2kfhb/YBE3kWrl/Q+Nr/qGsUaPV0hPTmIBQXAoISc4yPfPJJTQEJ
qSUR1pyeK9/3OnaOT/0+YHCOa1PqxUsUSgUEUjYty3aVRys1vP/M/qlSnjUl3rOcFtpDwa2C
B+hSEKQXZuwUo8VRzf8/NTD2CMT58gwYAuswOCbH6kDRAlBX7nwmw7Jp0U5ONWCp7HVQJvtC
w98AkIrxhL4j1G3Qu7XxP726XQ0xGYFaDPzojL9IRMAr/kxlrN+8/LHtnxJSnVxrwvxfuSB7
B7FrEn9FeBu9nUGfGm1bFhhMjYb7Dv9IIvt2MvZL

/

  GRANT EXECUTE ON "HR"."PLJSON_PRINTER" TO PUBLIC;
--------------------------------------------------------
--  DDL for Package WEB_PKG_LOGS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."WEB_PKG_LOGS" is
    g_sqlcode  number;
        
    function logs(v_type in varchar2, v_client_msg in varchar2, v_msg_error in varchar2, v_owner_name in varchar2, v_caller_name in varchar2, v_line_number in varchar2, v_caller_type in varchar2) return varchar2;

    function info(v_msg_error in varchar2, v_client_msg in varchar2 default null) return varchar2;

    function error(v_msg_error in varchar2, v_client_msg in varchar2 default null) return varchar2;

    function warning(v_msg_error in varchar2, v_client_msg in varchar2 default null)  return varchar2;
    
    function debug(v_msg_error in varchar2, v_client_msg in varchar2 default null)  return varchar2;
    
    procedure routage(v_msg_error in varchar2, v_client_msg in varchar2 default null);

end;

/

  GRANT EXECUTE, DEBUG ON "HR"."WEB_PKG_LOGS" TO PUBLIC;
--------------------------------------------------------
--  DDL for Package WEB_PKG_ROUTER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."WEB_PKG_ROUTER" as
    routes pljson;
    procedure bootstrap( req varchar2, res out clob, mess_err out clob );
end;

/

  GRANT EXECUTE, DEBUG ON "HR"."WEB_PKG_ROUTER" TO PUBLIC;
--------------------------------------------------------
--  DDL for Package WEB_PKG_ROUTES
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."WEB_PKG_ROUTES" as
    function getRouters return pljson;
end;

/

  GRANT EXECUTE, DEBUG ON "HR"."WEB_PKG_ROUTES" TO PUBLIC;
--------------------------------------------------------
--  DDL for Synonymn JSON
--------------------------------------------------------

  CREATE OR REPLACE SYNONYM "HR"."JSON" FOR "HR"."PLJSON";
--------------------------------------------------------
--  DDL for Synonymn JSON_LIST
--------------------------------------------------------

  CREATE OR REPLACE SYNONYM "HR"."JSON_LIST" FOR "HR"."PLJSON_LIST";
