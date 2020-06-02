--------------------------------------------------------
--  File created - Tuesday-June-02-2020   
--------------------------------------------------------
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
--------------------------------------------------------
--  DDL for Type PLJSON_VALUE_ARRAY
--------------------------------------------------------

  CREATE OR REPLACE TYPE "HR"."PLJSON_VALUE_ARRAY" as table of pljson_value;

/
--------------------------------------------------------
--  DDL for Type PLJSON_NARRAY
--------------------------------------------------------

  CREATE OR REPLACE TYPE "HR"."PLJSON_NARRAY" as table of number;

/
--------------------------------------------------------
--  DDL for Type PLJSON_VARRAY
--------------------------------------------------------

  CREATE OR REPLACE TYPE "HR"."PLJSON_VARRAY" as table of varchar2(32767);

/
--------------------------------------------------------
--  DDL for Table WEB_LOGS
--------------------------------------------------------

  CREATE TABLE "HR"."WEB_LOGS" 
   (	"MESS_UID" RAW(32), 
	"MESS_CLT" VARCHAR2(600 BYTE), 
	"MESSERRO" VARCHAR2(1000 BYTE), 
	"TYPEMESS" VARCHAR2(2 BYTE), 
	"OWNER_NAME" VARCHAR2(30 BYTE), 
	"CALLER_NAME" VARCHAR2(30 BYTE), 
	"LINE_NUMBER" NUMBER, 
	"CALLER_TYPE" VARCHAR2(100 BYTE), 
	"DATEERRO" DATE DEFAULT sysdate, 
	"CREATEBY" VARCHAR2(30 BYTE) DEFAULT upper(user)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GED_REFE
--------------------------------------------------------

  CREATE TABLE "HR"."GED_REFE" 
   (	"IDETYPDO" VARCHAR2(20 BYTE), 
	"MOT_CLE" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GED_REFE_DOC_BIN
--------------------------------------------------------

  CREATE TABLE "HR"."GED_REFE_DOC_BIN" 
   (	"MOT_CLE" VARCHAR2(20 BYTE), 
	"IDEDOCBI" NUMBER(10,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GED_TYPE_DOC_BIN
--------------------------------------------------------

  CREATE TABLE "HR"."GED_TYPE_DOC_BIN" 
   (	"TYPE_DOC" VARCHAR2(20 BYTE), 
	"IDEDOCBI" NUMBER(10,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GED_FICHE_DOC_BIN
--------------------------------------------------------

  CREATE TABLE "HR"."GED_FICHE_DOC_BIN" 
   (	"DESDOCBI" VARCHAR2(20 BYTE), 
	"EXTDOCBI" VARCHAR2(20 BYTE), 
	"CLEDOSAR" VARCHAR2(80 BYTE), 
	"SOUDOCBI" VARCHAR2(20 BYTE), 
	"AUTDOCBI" VARCHAR2(20 BYTE), 
	"DATDOCBI" DATE, 
	"REFDOCBI" VARCHAR2(20 BYTE), 
	"DATERECE" DATE, 
	"VERDOCBI" VARCHAR2(20 BYTE), 
	"RESDOCBI" VARCHAR2(200 BYTE), 
	"NOMBPAGE" NUMBER, 
	"DATEENTR" DATE, 
	"DATETYPA" DATE, 
	"DATECLAS" DATE, 
	"IDEDOCBI" NUMBER(10,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GED_STRUCTURE_ARCH
--------------------------------------------------------

  CREATE TABLE "HR"."GED_STRUCTURE_ARCH" 
   (	"IDENDOSS" VARCHAR2(50 BYTE), 
	"IDEDOSPA" VARCHAR2(50 BYTE), 
	"DESIDOSS" VARCHAR2(50 BYTE), 
	"ORDRAFFI" NUMBER(3,0), 
	"TYPEDOSS" CHAR(2 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GED_ANN_DOC
--------------------------------------------------------

  CREATE TABLE "HR"."GED_ANN_DOC" 
   (	"CODETYPAN" VARCHAR2(20 BYTE), 
	"TEXTANNO" VARCHAR2(300 BYTE), 
	"DATEANNO" DATE, 
	"IDEDOCBI" NUMBER(10,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GED_CARA_DOC_BIN
--------------------------------------------------------

  CREATE TABLE "HR"."GED_CARA_DOC_BIN" 
   (	"CODECARA" VARCHAR2(20 BYTE), 
	"LIBECARA" VARCHAR2(700 BYTE), 
	"TYPECARA" VARCHAR2(20 BYTE), 
	"DEFAVALE" VARCHAR2(20 BYTE), 
	"CARAOBLI" VARCHAR2(20 BYTE), 
	"ORDECARA" NUMBER, 
	"NOM_TABL" VARCHAR2(20 BYTE), 
	"COLO_CLE" VARCHAR2(20 BYTE), 
	"COLOLIBL" VARCHAR2(20 BYTE), 
	"POIDCARA" NUMBER, 
	"IDEDOCBI" NUMBER(10,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GED_DOC_BIN
--------------------------------------------------------

  CREATE TABLE "HR"."GED_DOC_BIN" 
   (	"IDEDOCBI" NUMBER(10,0), 
	"LOBDOCBI" BLOB, 
	"IDCLIENT" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
 LOB ("LOBDOCBI") STORE AS BASICFILE (
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192 RETENTION 
  NOCACHE LOGGING 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;
--------------------------------------------------------
--  DDL for Table GED_CLIENTS
--------------------------------------------------------

  CREATE TABLE "HR"."GED_CLIENTS" 
   (	"IDCLIENT" NUMBER, 
	"PRENOM" VARCHAR2(20 BYTE), 
	"NOM" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
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
--------------------------------------------------------
--  DDL for Package WEB_PKG_ROUTES
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."WEB_PKG_ROUTES" as
    function getRouters return pljson;
end;

/
--------------------------------------------------------
--  DDL for Package WEB_PKG_ROUTER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HR"."WEB_PKG_ROUTER" as
    routes pljson;
    procedure bootstrap( req varchar2, res out clob, mess_err out clob );
end;

/
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
--  DDL for Package Body PLJSON_PRINTER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."PLJSON_PRINTER" wrapped
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
b
454e 100c
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
JFRvok6Ubl/5mw+v7V4n

/
--------------------------------------------------------
--  DDL for Package Body PLJSON_EXT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."PLJSON_EXT" wrapped
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
b
53cc 154e
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

/
--------------------------------------------------------
--  DDL for Package Body PLJSON_PARSER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."PLJSON_PARSER" wrapped
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
b
6345 1755
Xjheqx4HoXJNPAqGgEg8jK/j8tYwg82kc14FVzM/uQ9rVb6IxgxavVB5qHnBWVFQoNxuLaSe
asBYjhWnpFpTL0iYXs6auwAQtPFWBb0sYtqx/3sUYdLSvNK8FEL4h07WxAz63FB7ypzBqnEu
SWrZs4oneu+H0l/IFzyqRqARA+uB5D9QKZWRcpkTuzS47QlJzrFsBSDjXserNrozag6hutbI
8TWdQ5X1TTIB1opQVdwo+dPTzE/fC9Oyn1FX2IpC+akroaT5xzELffMRhAOYzXx98UEssu+r
6ZAOeIoSa7Fjf7LvM+SG2p6MSXi9ygc7EtbRstrXqFGKKi0N66kzoLHCOINnoxSEcEc1ZIhq
VBqA/gs5USUpDTO9plVrOI2iqdW9OX8pRNcOqmcZgKnqjt9M0yUwLzPTQVh2faCtDsQU5Tqg
wfHOpM363O03u3gEQJCf1ip4IiUZE/b29pFEqTbNn6IL00ZGAEJzG77GOLCQoYOrNoWjZNPL
ZP2gBKLEqKMYJJCfg4D1oXDspre7CnSJRhoJ1qSpobRFDevwQD9LXrZFpihALs5MAZAKvaCN
Rd0+apSvA6CqtNhljuoBD3fVqJtATE0ebaEN8jRIfKYyi7I16QUZ3dD7NExoyqU12pDf/R6W
qhD6F7Jer8P9gxbfdqCHCvSo5Mp9mcmoL31GqkhIdC5xO2T15fcV/YqxaYgdVdjb/oSexwJm
A9Xnq50U9dIQYIIh4xFUt9IM5eCDzcEhsykVQOYOrKxgIyRcWCpDSEqHZ+om0/LBotW0AHWA
o7FMq2o7Vc6kM58q6HD4ZuIUZV5EzvVTjGVjh1yw2Jfj6fSuLr9tuXSf1X8RdeagOL4EEjjA
0ltSsuJrminMPJUNaooHcCsHUqU3M8V/vTGclal7+TGRNC5uExNTQHhISHZ8xdcpOoGVomhI
OSKd/bUyPhPUWxB7ije2yM1JTgiR0Rysr/4UUcUnJbmwMICEq0A1TceM8i/322ndpQYSQFFQ
HqL1fYH4P7Apaye9uAoe9jJ34FsyrKLGjPo2bqXO2QjOwD/fkMiq98ehDRo6V2NXax/0+sFC
y7ln3kGmHKZMpnEDDl/EmbPci4d44hFuQKGOsjXm9ZwIo7Uxl9wM3KNlsjHQaVrqE78w1Vy2
bsVShEIVol9OgO30UUASLoEcxbYDV5LS8e/J59IpIrGnlxJuhULcOZUaJIbDuMTJegl1UbSw
XUFdOUoKkmbJZQnqkTDlLjh87LsRTh0jjud2HU8jOe8CCyUACY3KUuGmNsW050CTMqJf73wx
yf6rbhSIB9jIRRz+idBwdAOLUycR8csbvDcdAt+nODIPunzKge9/aLoEZLkvKKWVTy/ArbpD
aoxYcqQ/OFZ8aM3OIa8LYm0H0zVo+7eVyFDvSll+p5djn67UVqxZ5TtQws068+39ZCFXUlcO
8CDZYNTEhy+w41NgU2JfA4SdcUrQwYa3ecDAM/gx5BhuLoUpfvVf6DE4QNsNlZpCwOHZCVLU
ULNrSvjOm/INC5Wv25VLjpqsKd5gm4RCaULUD9EfUP0p4bZbhSmzNMpmxYbY27v6FgxO44+s
ne0kNurqdRPey38IB2dE94lWwee+0wKpFT8sUQUoiVu7/50oKMSAwbcebc2MmkCAtdu+v0DH
rrM+N8XdH5pGg1pSmvY50yII7yvHfCEBeOMdkajyFlz6du1aKqWB9rPBzbqMfmvldLBsjGUK
MlzetN2nBtMMo/5AZ6ugGmKERDBzcCDnPgmhq9aTBsZLtl7nz/vx4cLFA0k51JSPce3ARh0B
ZnoRPCnNIkpg6lK4GoCOj57S2gFKR5ZCXN4gtMMMBN4/QsSICH90I5gzfWnqRyMLJliszT8j
7/o9i4QnixRiIPoKkitM25z0UcI5JhhUXHELjo9EWFLP3WWbGAVpo2yDJXQ+5xyCfcrSFR0u
C1CD1e31teaK5bps1ocHHzX3c+IlJJD+yqmiSCbdR/PTv4PPHyv8/Uj8CQjUpwiYvIuLrTlH
dRfrx8DkQkYt2zCf6RvrrYiQT661dk/InlvqlGnbEUg3mmlMcyDov65DMpaW50GxbU1mwtBN
dKHDt4hh3cIbP5PuvuRF5jz9q1/P2B/GaKIzF/UdcpzdV1s9koxRGCMpV5N2NTxoJTeofuDt
deleb+C5odyINW232/F7J/Xc6Go9z5+fep11QV/6xTlaZhGSWORgQbeuXYlZhV9H+ip/yalV
nnXC+UbCIpUoX7SQiD9HeVGd/ihuLFfin7eoHVq4Bd63W/+76jnMNLHeoWSSRQ0FGtgF7A0F
2NgFQA0FNBoFp+mHhSZgIu+dcnGYn/L1UUS8lZkuKkhb1ny6tKEvoTQNs4SVSmRK2HetrFzg
4ffMqVhXPjk4pghcVPMB9namHjwypWd1JktCS4vDkHtxHrh53Q29sZlTPwIebHFkj4Os2db2
W+IbcWJTFnF5U2C4r3HASu57N5klVGlp7oYJNpNgyViJOjDitS6laM4Tj746jgiRzdjR8lI2
7M2d4nbiO0ikpCMKze/+Hos7Pc79PscthtYEQ4s5QpEVS4MTH2z/pZVVkGtNcR8wgNoMl2hr
3qMqS7/LRBzi54noLXKX8QtiV3Xk3NS3tuTWOJsp0iPA4FBBO0ERDXjvLr0GiqnZbChlsxw5
EiF++K+A/wAxcn7JurhcgPvZcgOvGuHcYi/1ccKNYBI447DZNHyR6CWVmWyhkh4DaK0lbz9m
QsT3i1En7HTOPLdjbjivCx5F45opshI38YRt1NfdsbtkKT5/2XmVh22xIHUbm1UsMdKfa6x4
LMucY87EivKsp44m7tvq8x9S0VwUH1QVmvDVpTTFhdiefVzijfCJCxHqQ795iyYdVad09fhp
HVwMOeUid2cFbB15JHdnB2wdpCJ3Z4BsHaQAd2dOWS9tPScAUFlqWdimrU4xgbSnKDHrWStu
ctUDhz8ceSw+6SttmHKGpnhevn6FCJUnQpjsN9cKEFj/p5NiJ/cbprwTr6c6pwxjVh4u6lt2
0eFJhM/e6BM3T8ZMX/+5jOCnV3CEqic45TwVoodcg/qb8tq+IiS1a6CaXN5Y5xxe3vf0rure
rpxpgx9x3q6AweokWc3+PaPR1sbDuhuYWzwF1wntVVYlukw31afpng0lbKwgia21yXCcSrzo
XVWIUP3+RHlHKByXhhz7LY+NRE+2PdmX7KgLEADG1PSb5ozprkesRvp1YngxTQIeAqef2EgD
GF4SsiT8zi1KLP3OLfQslqWG6uQw9CxkpQvZLcjIIHF/AqPb5005ylVxnPbhK8c2RXX7EXq6
yQYKM84XFziDH3ipns2XwscczVzbFe0oOuisYsbhcWLmTzhObK6peKW7+Ueo2cfBP+I90tgo
l1NDesUEVtUXJcXDhzLVnO6n7eSVhJHDIYYfuwpOk7cjrq3WfiBIwHrh3BPBnZEuB3k7SZsz
TcBf6XtEVah0I4SrKr2avgmgy8OK6qBiIP4PX9djJF51Gbvb7C46Q75eaGDDIANIzCbSxZ5H
S6q3pcABVatFb7WOetG03AlTY0a/cn5Jk1/Zb6+Jv0WMuGUoPE4cfl3j62ZQwZ1UopcYCBgh
zZkq8loAdYWNvcAq+XKBMMB6G+dYR7BUCkmxtwg9CH3THE9fi++f3DdYtBUOBSL4nA9M+jHP
G0PidgUm8aCJSOsZldPFRXFgXOBqk2Msf0zKWMJ1IBl4HlYfrmNlkjRI0EIf3xeDJ5zlbdst
YBVADC0+pEiQxT3l9QDYuNWwONh3Xhv3wshmv7HswXWSKBJvTdFy4YE6CO7GrZ7b/9dCOFSz
H8entAjZNDua9OC+VjaOAmvP3Up2hrK7pohB7bqh0EdSFsXboFv5iS7Hvyvo2Iud+BKDqZLT
91K8nOtMC8jpMxRE/HFZFwtlIiwPX0nP/jMR3/1z6fl2TL0mX7cyWtdIqCLPQO566hVXvIHT
Y4kcSpL0YigR1cNf6Sq8ehYyvjCNp3kAJY/8TvAfqa1CdEVogynsJSYEh/e/wSrwApJO1xEb
pivZuhqdMcx1PDTiX6XQ4N5sJARvrD19IQWYR7m0/b5v/ad1c5W0J8vqbBuwwJcqZVx4EGUR
vq3jvC0KneoL688WJTPIMxBkWFEJlV6EXM0ApuI53eYlQfpGanSHZvVAGYs0SFakOet3HH05
2aMgRwbZ+LEGcBHrfBMX8R5hcm/1eZNvqFGv/xKks3qOdOqxeAynkaL52nudHLrfteXaAJtp
cUf/pAH+XARSVOLpt6Em4FC08lLJZDDRKCyxjpzKIIC1hfo8s9NZkgMIlRE/8H3PrRNJTVR4
hhpUpYTwn9lkKI1cN8VY/4XM/zMg+BK9U4OGxmm5HDjs5XmO983x64PgGJNmAtHNb2Ceg/Oe
EUe9WdaoNGMa/8kErxsCX+8OO5XvVkOGx2xBHkmCh9MtFvXwk8YRHlEFzl+WoPWzBSfRYKD5
HCJyiwjYVsXHx5JP4VvqBhm5KWgUuRJ7N+h42ac3VofNk4f3sLRSVrkxNsKV/1bvVuv3Qwvv
WC1GwSXkK+DCg33mkWbxWX89uClKmTniMu28z6GpIXaDhPRhIajATg6NqzgrDjvJd7QggWJZ
6BAMJrwLG4mK8B1RUjBndsHgis3OiTZ5WAOmWUWun8tf/jbjaMQSqVUwIEIcJf4mrph5pfRi
Qp5ZMVv/q/ub4ZmYJiHNUulCkPqbPhP3oQiJYEhT60xT8SWOzo/Cjhv25wM3wObgkrmndy99
lrgt3HefbDfIv0rwZLsKm0sr0be+UEW8eiTaHNeo3FNTbrXp0dQfT9RUA0sc4Prihx5Rcm4y
/0waYKNp0NMYaPFc+5nUdupliEylwNY2jelVoje5eN4swY1ChVEfS1qRhfru+WpnglWLWLQD
W20sjSXzp0mwsC9TTIdyuwSCPwuRfn/8n58B5ZE6BhC/SUnr1Kr4l74e5OmZYN9vScDcQ48E
Jbcaf4xx+1k9hUdowoFKXT8CsZP7wEgGK+yird3RsBTmSV33GjD+ehqjFoZRfVG4FvhwxEp5
tYQ1g9a7VxTrrqqmmW5EdITc4fX2MSiNdPz3himVleNx8JbGA7N2JQ4D1cCtEz+rEHtbbSOf
MjLfOu2i4mgQaKtBHRDJBl13De8w3ZobG07oFPYJBpkRw3bnbOxJSpami8QCPjTM1tymVewm
vonBJ6RqMRcbCb4NGUtRTzzEgJankHPJ9cxLjU+QbEudGNebG1r6gf4GkPaLE+5dHqbToM7x
vrSq8by1WlzATGOd/EWNeDga0VRqmkf0X9pvu+o1yF3VfWoRG0PerRX3yO90iq52uvB06Xji
Iq5kcr46WKocgjz2gmXubfZCnePi2aHYfgy1Qoi8ZzegAqngYgnA6J33xaTRZPKtPlUl5V1P
TNfH0imlNYEpheWufs74xY0vIzfgMRlKOhSNGHnfzmtprsNrFXoBkuLRufOBfQfQEhYswYHL
nkxuKxqHtHb7dAw8gaB6D0WobPeX8lU9D48pdq0+jWxvKdqr9IPa/A3F4kjVZ8Lp4cS+QZi9
+CnOQbUf9yfaUuaDsjOp9x1IxBHDNZdH09FmhuyBg6SrwhGEOzEn5cjqvo2UK6YvPqklm2IV
j8ohMJsQOAY9cD9bMg5skFwbKgHsjaSDM0DHCQp/YSrXsW7WdAj50fDVpHgmmAUekHuLqdyD
6+w6nstUObjHI8GdH8ruYPDt4H+NsGHs6NiZj4UNn0mJfurEJRQFLEKtD5rY7Ep3LNuNGlqV
FswqgtqruYTDHsWSnthNjrB0Rwrd/Odw9PIeFxMEG79npT4HFGRi0ImV4TPL5/uVRdp0oipo
HWUIEvq1FzV6n5L5x+i+D53yKsFzICC3tf1G4ZRAC8eTEPQShiy1HU1qtTY=

/
--------------------------------------------------------
--  DDL for Package Body WEB_PKG_LOGS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."WEB_PKG_LOGS" is
    function logs(v_type in varchar2, v_client_msg in varchar2, v_msg_error in varchar2, v_owner_name in varchar2, v_caller_name in varchar2, v_line_number in varchar2, v_caller_type in varchar2) return varchar2 is
        pragma autonomous_transaction;
        xuid varchar2(100) := SYS_GUID();
    begin
        insert into web_logs(
            MESSERRO, mess_clt, typemess, owner_name, caller_name, line_number, caller_type, mess_uid
        ) values (
            v_msg_error, nvl(v_client_msg, v_msg_error), v_type, v_owner_name, v_caller_name, v_line_number, v_caller_type, xuid
        );
        commit;
        return 'ORASS-'||xuid||' : '|| nvl(v_client_msg, v_msg_error);
    end;
    
    function info(v_msg_error in varchar2, v_client_msg in varchar2 default null ) return varchar2 is
        v_owner_name    varchar2(30);
        v_caller_name   varchar2(30);
        v_line_number   number;
        v_caller_type   varchar2(100);
    begin
        owa_util.WHO_CALLED_ME (v_owner_name, v_caller_name, v_line_number, v_caller_type);
        return logs('I', v_client_msg, v_msg_error, v_owner_name, v_caller_name, v_line_number, v_caller_type);
    end;
    
    function error(v_msg_error in varchar2, v_client_msg in varchar2 default null ) return varchar2 is
        v_owner_name    varchar2(30);
        v_caller_name   varchar2(30);
        v_line_number   number;
        v_caller_type   varchar2(100);
    begin
        owa_util.WHO_CALLED_ME (v_owner_name, v_caller_name, v_line_number, v_caller_type);
        return logs('E', v_client_msg, v_msg_error, v_owner_name, v_caller_name, v_line_number, v_caller_type);
    end;
    
    function warning(v_msg_error in varchar2, v_client_msg in varchar2 default null ) return varchar2 is
        v_owner_name    varchar2(30);
        v_caller_name   varchar2(30);
        v_line_number   number;
        v_caller_type   varchar2(100);
    begin
        owa_util.WHO_CALLED_ME (v_owner_name, v_caller_name, v_line_number, v_caller_type);
        return logs('W', v_client_msg, v_msg_error, v_owner_name, v_caller_name, v_line_number, v_caller_type);
    end;
    
    function debug(v_msg_error in varchar2, v_client_msg in varchar2 default null ) return varchar2 is
        v_owner_name    varchar2(30);
        v_caller_name   varchar2(30);
        v_line_number   number;
        v_caller_type   varchar2(100);
    begin
        owa_util.WHO_CALLED_ME (v_owner_name, v_caller_name, v_line_number, v_caller_type);
        return logs('D', v_client_msg, v_msg_error, v_owner_name, v_caller_name, v_line_number, v_caller_type);
    end;
    
    procedure routage(v_msg_error in varchar2, v_client_msg in varchar2 default null )is
        v_owner_name    varchar2(30);
        v_caller_name   varchar2(30);
        v_line_number   number;
        v_caller_type   varchar2(100);
        
        x_uid varchar2(40);
    begin
        owa_util.WHO_CALLED_ME (v_owner_name, v_caller_name, v_line_number, v_caller_type);
        x_uid := logs('R', v_client_msg, v_msg_error, v_owner_name, v_caller_name, v_line_number, v_caller_type);
    end;


end;

/
--------------------------------------------------------
--  DDL for Package Body WEB_PKG_ROUTES
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."WEB_PKG_ROUTES" AS

    FUNCTION getrouters RETURN pljson IS
        routes   pljson := pljson ();
    BEGIN
        -- Définition de toutes les routes
        routes.put('test_info','ged_core.test'); -- Just to Test
        --routes.put( 'doc_insert', 'dml_ged_doc_bin.ins_ged_doc_bin' );
        routes.put('doc_fiche','dml_ged_fiche_doc_bin.ins_ged_fiche_doc_bin');
        routes.put('doc_types','dml_ged_type.select_all_types');
        routes.put('doc_typage','dml_ged_type_doc_bin.ins_ged_type_doc_bin');
        routes.put('doc_caracterisation','dml_ged_cara_doc_bin.ins_ged_cara_doc_bin');
        routes.put('doc_referencement','dml_ged_refe_doc_bin.ins_ged_refe_doc_bin');
        routes.put('doc_identification','dml_ged_clients.ins_ged_clients');
        routes.put('doc_identify','dml_ged_doc_bin.identify_ged_doc_bin');
        routes.put('doc_iden','dml_ged_clients.select_fields_clients');
        routes.put('doc_caras','dml_ged_cara.select_caracs_chosen_type');
        routes.put('doc_ids','dml_ged_doc_bin.sel_ged_docs_bin_ids');
        routes.put('doc_blob','dml_ged_doc_bin.sel_blob_doc_bin_by_id');
        routes.put('doc_motCle','dml_ged_doc_bin.sel_blob_doc_bin_by_keyword');
        routes.put('docs_struArch','DML_GED_STRUCTURE_ARCH.sel_structure_archive');
        routes.put('archives_ids','DML_GED_STRUCTURE_ARCH.sel_structure_archive_ids');
        routes.put('annotation_types','dml_ged_ann_type.sel_ged_ann_type');
        routes.put('doc_annotation','dml_ged_ann_doc.ins_ged_ann_doc');
        routes.put('docs_nonType','dml_ged_doc_bin.sel_ged_doc_bin_non_type');
        routes.put('docs_nonClasse','dml_ged_doc_bin.sel_ged_doc_bin_non_classe');
        routes.put('doc_classer','DML_GED_STRUCTURE_ARCH.classer_document');
        routes.put('doc_retyper','dml_ged_type_doc_bin.upd_ged_type_doc_bin');
        routes.put('doc_del','dml_ged_doc_bin.del_ged_doc_bin'); -- delete document totally
        routes.put('docs_annotations','dml_ged_ann_doc.sel_ged_ann_doc_id');
        routes.put('archive_create','DML_GED_STRUCTURE_ARCH.create_structure_arch');
            
        RETURN routes;
    END;

END;

/
--------------------------------------------------------
--  DDL for Package Body WEB_PKG_ROUTER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."WEB_PKG_ROUTER" as

    procedure bootstrap( req varchar2, res out clob, mess_err out clob ) is
        params_json  pljson;
        response     pljson := pljson( );
        route        varchar2( 200 );
        handler      varchar2( 200 );
    begin
        routes := web_pkg_routes.getRouters();
        -- add verification token if is valide execute function else error login
        params_json  := pljson( req );
        route        := pljson_ext.get_string( params_json, 'route' );
        handler      := pljson_ext.get_string( routes, route );
                
        if handler is null then
            mess_err := web_pkg_logs.error('Ressource demandée est introuvable ['||route||']', 'Ressource demandée est introuvable ['||route||']');
        else
            begin
                execute immediate 'begin ' || handler || '(:params_in, :mess_err, :params_out); end;' using params_json, out mess_err, out response;
            exception
                when others then
                    rollback;
                    mess_err  := web_pkg_logs.error(sqlerrm, 'Erreur à l''execution de la fonction '||handler);
            end;
        end if;
        
        if mess_err is null or mess_err = 'OK' then
             
             res := response.to_clob();
            commit;
            mess_err := 'OK';
        else
            rollback;
        end if;
        
    exception
        when others then
            rollback;
            mess_err  := web_pkg_logs.error(sqlerrm, 'Erreur de Routage!');
    end;    
end;

/
--------------------------------------------------------
--  DDL for Package Body PLJSON_DYN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."PLJSON_DYN" wrapped
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
b
2383 7fc
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


/
--------------------------------------------------------
--  DDL for Package Body PLJSON_AC
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."PLJSON_AC" wrapped
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
b
3125 65e
mslkesTX48WS+mEUGyeIar2XDn4wg1WjTNAFFo7Nx6pE0KTew3n+Jj16OAcUQag5OHYukuBc
EArlVY0ztQyZOXbGvKmkqhST3iEl24tux5acmW50xin9GfOJS9e9c074sZ2qtVxzzvS4CPOo
0VTy32PK42xkFI2NylufFE8wXC9F6ZNKVD7M/wnUruPrsaxDcuOGWcOtIi/122ZVCwjBtzUM
hdzwfAsk2hT+m+uZZjqLRGZDY3bZESTa4KPT+Ow6hABw6RuC6EZQUZfAoZ+iDrIxBvHFj/EJ
Wnliry2gr3IwmTlQkqUI28FDqKjgsikMTa7Cdm1eDTgB5iwDMNPUFq86LqCwEvG8XBPx61aV
ZSV4Svxr9cCoYkygI2epVaB1Tqlm27u7zGKp6Qw7Qs0IJ0efVOyUwGMCvGJOoBtSjdSXNKTW
E8M1kT7ABUaDNDM31WIANK+7rLtaLKsZwXYn9sYItzxLc3MgytrIQ/bOEvrNJRc6QDTqftrR
HS1GT8yGvcq75eLUswXRBsHEdRDAqQ/C8owdnp5KXgkhfuKFY1AyCsaOlEnmO21ozdbX2qoh
o5AwnVRJ3VAy9x0eoygaVvuJSQG/Jh4f7fN5f2IGqADvZrg1J9x8PlCXv6uNZoCabCeGQEV1
hcCtu1YQc5suMnuyanJOjs0BDcsPFipUyhjtXWoLBHuW7+9Qqzn8B7HZvnPOEptLGzL7i3nz
dtkAyA0jGj88g2HTXKFVdBCIPuXo9t2yyV125RltIAPIh+b6a8cCCEamw1ELed49MEyVx9l5
nrIAqVQKsmJmn/vtkNX6VcGxgdgHFkA8oTNSXWagn4HLCDdgIQ/Q5tnTJ6DdODH1+mZFCHfH
dnt2ug5QrzQj77CtdSFZ2tht2wuopSYVbgrBa4kF+B9LOHEybANG6NHmnIX20i6goG893/ot
GBYTVkjLhCezii5OE2+N31XoBCSYrLjlyyUdFOasqT10/Vyn2+Z1OPmg12bFirmaZ8iTxLGF
k/KzleDtE3pEVjwTfd7tv0NdKtoDzEQTN6ePxYBLLL+K5Lbn2tIyVKCGk64jE/TmYDod6J+y
LwtrMKv0HJokIoiehTx0G3ncIOtatLY09In6fN+yXe8pXaUj8WllbP99fPGlk8OGNm+ncr0N
Tp/En32TAF1Ao4G11Qx3onTaUesX9i66d9Fc3ZSyxlIPPE2QKIXooDho1AqKXEemJGbKMEwD
wCL61YinTr2HcqBurk4j1ENf7LF/lhcPzwyIdSI91ijbHkWs19Qszub87AME5DvD+LD3pSPY
8OZCBqYN7bMoIpJXGvmtUCWOCc3C2iizgnuP/sWtoQmUMf6Hl4GnF4ezxTRkX4n2lEx8v1QO
lH9WHM5HOY3cmVmyI5sbUDZ2Eya0zQhfNqdjQ2WQfNQys99qiYukIH5FWOkx4LWt7qnhiBr1
QfKxWrzkAekBfs76+ypacKL83lWiiw4mN89Wr/Is6QvIz3pqns/nrrDd2noDjhOVCMbmKXr3
zpnXEsENYn1Ilu0r2jCGsmFyW+2b5TAA/lUpgg2LAuqV+xmfasxosTLqlWnZAvkgpWAX92By
yLeFgIEF+pUp2Qe1prAaq3g=

/
--------------------------------------------------------
--  DDL for Package Body DML_GED_TYPE_DOC_BIN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."DML_GED_TYPE_DOC_BIN" IS

    PROCEDURE ins_ged_type_doc_bin (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    ) IS

        result        pljson := pljson ();
        in_idetypdo   VARCHAR2(30) := pljson_ext.get_string(v_params,'IDETYPDO');
        type_doc      VARCHAR2(30) := pljson_ext.get_string(v_params,'TYPE_DOC');
        idedocbi      NUMBER       := 0;
        cmot_cle      VARCHAR2(30);
        CURSOR c1 IS SELECT
            mot_cle
                     FROM
            ged_refe
                     WHERE
            idetypdo = in_idetypdo;

    BEGIN
        
            idedocbi  := to_number(pljson_ext.get_string(v_params,'IDEDOCBI') );
    
        IF
            LENGTH(in_idetypdo) > 0 AND LENGTH(type_doc) > 0 AND idedocbi != 0
        THEN
            
            INSERT INTO ged_type_doc_bin (
            idedocbi,
            type_doc
            ) VALUES ( idedocbi, type_doc );
            
            EXECUTE IMMEDIATE 'UPDATE ged_fiche_doc_bin SET DATETYPA = SYSDATE WHERE idedocbi = :idedocbi'
                USING idedocbi;
                
            result.put('message1','date type updated successfully');
                OPEN c1;
                    LOOP
                        FETCH c1 INTO cmot_cle;
                        EXIT WHEN c1%notfound;
                        INSERT INTO ged_refe_doc_bin (
                            mot_cle,
                            idedocbi
                        ) VALUES (
                            cmot_cle,
                            idedocbi
                        );
        
                    END LOOP;
                    
                    CLOSE c1;        
                        
            result.put('message','Type Affected Successfully To Your Doc');        
        ELSE 
            result.put('message','Type Not Affected To Your Doc');
        END IF;
    
        
        v_res := result;
        COMMIT;
    END ins_ged_type_doc_bin;

    PROCEDURE upd_ged_type_doc_bin (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    )
        IS
        result        pljson := pljson ();
        in_idetypdo   VARCHAR2(30)    := pljson_ext.get_string(v_params,'IDETYPDO');
        in_type_doc   VARCHAR2(30) := pljson_ext.get_string(v_params,'TYPE_DOC');
        in_idedocbi   NUMBER          := 0;
        cmot_cle      VARCHAR2(30);
        CURSOR c1 IS SELECT
            mot_cle
                     FROM
            ged_refe
                     WHERE
            idetypdo = in_idetypdo;
    BEGIN
          in_idedocbi := to_number(pljson_ext.get_string(v_params,'IDEDOCBI') );
          
          IF
                LENGTH(in_idetypdo) > 0 AND LENGTH(in_type_doc) > 0 AND in_idedocbi != 0
          THEN
            UPDATE ged_type_doc_bin
            SET
                type_doc = in_type_doc
            WHERE
                idedocbi = in_idedocbi;
                
            EXECUTE IMMEDIATE 'UPDATE ged_fiche_doc_bin SET DATETYPA = SYSDATE WHERE idedocbi = :in_idedocbi'
                USING in_idedocbi;                
                
            DELETE FROM GED_REFE_DOC_BIN WHERE idedocbi = in_idedocbi;
            
            OPEN c1;
                    LOOP
                        FETCH c1 INTO cmot_cle;
                        EXIT WHEN c1%notfound;
                        INSERT INTO ged_refe_doc_bin (
                            mot_cle,
                            idedocbi
                        ) VALUES (
                            cmot_cle,
                            in_idedocbi
                        );
        
                    END LOOP;
                    
            CLOSE c1;
            
            
            result.put('message','Type Doc updated');
            result.put('message1','date type updated successfully');
            
          ELSE
            result.put('message','Type Doc not updated');
          END IF;
          
        
        v_res := result;
        COMMIT;
    END upd_ged_type_doc_bin;

    PROCEDURE del_ged_type_doc_bin (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    )
        IS
    BEGIN
        --DELETE FROM hr.ged_type_doc_bin
        --WHERE
          --  idedocbi = in_idedocbi;
        COMMIT;
    END del_ged_type_doc_bin;

END dml_ged_type_doc_bin;

/
--------------------------------------------------------
--  DDL for Package Body DML_GED_TYPE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."DML_GED_TYPE" AS

    PROCEDURE select_all_types (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    ) IS
        result   pljson := pljson ();
    BEGIN
        result.put('types',json_dyn.executeobject('select LIBTYPDO, IDETYPDO from ged_type')); -- The data json_dyn.executeObject('select * from ged_cara') 
        v_res := result;
        COMMIT;
    END select_all_types;

END dml_ged_type;

/
--------------------------------------------------------
--  DDL for Package Body DML_GED_STRUCTURE_ARCH
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."DML_GED_STRUCTURE_ARCH" AS

    PROCEDURE sel_structure_archive (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson 
    ) IS
        result               pljson      := pljson ();
        result1              pljson      := pljson ();
        result_e             pljson      := pljson ();
        iddoss_in            VARCHAR(30) := pljson_ext.get_string(v_params,'IDDOSS');
        json_to_send         json_list := json_list();
        TYPE array_of_strings IS
            TABLE OF VARCHAR(90);
        archives      array_of_strings;
        --cledosars     array_of_strings;
        index_double_point   NUMBER;
        idendoss_fiche       VARCHAR(30);
        i                    NUMBER := 0;
        j                    NUMBER := 0;
    BEGIN
    
        FOR document_fiche IN (
            SELECT
                DESDOCBI, CLEDOSAR, IDEDOCBI
            FROM
                GED_FICHE_DOC_BIN
            
            WHERE CLEDOSAR IS NOT NULL AND DATECLAS IS NOT NULL
        ) LOOP
                 
                index_double_point := INSTR(document_fiche.CLEDOSAR, ':');
                idendoss_fiche     := SUBSTR(document_fiche.CLEDOSAR, 0, index_double_point-1);
                IF 
                    idendoss_fiche = iddoss_in
                THEN
                    result.put('title', document_fiche.DESDOCBI);
                    result.put('key', ''||document_fiche.IDEDOCBI);
                    result.put('isLeaf', true);
                    result_e.put(i, result);
                    i := i + 1;
                END IF;
        END LOOP;
        
        result1.put('children', result_e);
        
        result1.put('length', i);
        v_res := result1;
        COMMIT;
    END sel_structure_archive;

    PROCEDURE sel_structure_archive_ids (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    ) IS

        result               pljson := pljson ();
    BEGIN
        result.put('structures_archive',json_dyn.executeobject('SELECT IDENDOSS, DESIDOSS FROM ged_structure_arch') );
        
        v_res := result;
        COMMIT;
    END sel_structure_archive_ids;
    
    PROCEDURE classer_document(
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    ) IS
        result            pljson               := pljson ();
        in_idendoss       VARCHAR(30)          := pljson_ext.get_string(v_params,'IDDOSS');
        in_idedocbi_s     VARCHAR(30)          := pljson_ext.get_string(v_params,'IDEDOCBI');
        in_idedocbi       NUMBER               := 0;
        index_#           NUMBER               ;
        idclient          NUMBER               := 0;
        idclient_s        VARCHAR(20)          := '';
        cledosar          VARCHAR2(40)         := '';
        desdocbi          VARCHAR2(40)         := '';
    BEGIN
        
        IF  
            length(in_idendoss) > 0 AND length(in_idedocbi_s) > 0
            
        THEN
            index_#     := INSTR(in_idendoss, '#');
            idclient_s  := SUBSTR(in_idendoss, index_#+1);
            idclient    := to_number(idclient_s);
            in_idedocbi := to_number(in_idedocbi_s);
            
            EXECUTE IMMEDIATE 'UPDATE ged_doc_bin SET idclient = :idclient WHERE idedocbi = :in_idedocbi'
            USING idclient,in_idedocbi;
            
            SELECT DESDOCBI INTO desdocbi FROM GED_FICHE_DOC_BIN WHERE IDEDOCBI = in_idedocbi;
        
            cledosar    := in_idendoss || ':' || desdocbi ; --Designation
            EXECUTE IMMEDIATE 'UPDATE GED_FICHE_DOC_BIN SET CLEDOSAR = :cledosar, DATECLAS = SYSDATE WHERE idedocbi = :in_idedocbi'
                    USING cledosar, in_idedocbi;
            result.put('message','Document bien classé');
        ELSE
            result.put('message','Document non classé');
        END IF;
        
        v_res := result;
        COMMIT;
    END classer_document;
    
    PROCEDURE create_structure_arch (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    ) IS
        result       pljson          := pljson ();
        NOM_STRUCT  VARCHAR(30)     := pljson_ext.get_string(v_params,'STRUCT');
    BEGIN
    
        IF 
            LENGTH(NOM_STRUCT) > 0
        THEN
        
            INSERT
            
            INTO 
                GED_STRUCTURE_ARCH
            
                (IDENDOSS, DESIDOSS, TYPEDOSS)
                VALUES
                
                (NOM_STRUCT || '#', NOM_STRUCT, 'S');
        
            result.put('messageSuccess','Archive inserted successfully');
        
        ELSE
        
            result.put('messageFailed','Archive not inserted');
        END IF;
    
    
        v_res := result;
        COMMIT;
    END create_structure_arch;
    
END dml_ged_structure_arch;

/
--------------------------------------------------------
--  DDL for Package Body DML_GED_REFE_DOC_BIN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."DML_GED_REFE_DOC_BIN" IS

    PROCEDURE ins_ged_refe_doc_bin (
        v_params      IN pljson,
        v_err         OUT VARCHAR2,
        v_res         OUT pljson
    )
        IS
        result   pljson := pljson ();
        MOT_CLE    varchar2(20)       :=    pljson_ext.get_string(v_params, 'MOT_CLE');
        IDEDOCBI   number             :=    TO_NUMBER(pljson_ext.get_string(v_params, 'IDEDOCBI'));
    BEGIN
        INSERT INTO hr.ged_refe_doc_bin (
            MOT_CLE,
            IDEDOCBI
        ) VALUES (
            MOT_CLE,
            IDEDOCBI
        );
        
        result.put('message', 'Doc Referenced Successfully');
        v_res := result;
        
        COMMIT;
    END ins_ged_refe_doc_bin;

  -- No Primary Key!  Cannot create UPDATE procedure for GED_REFE_DOC_BIN using primary key. 

  -- No Primary Key!  Cannot create DELETE procedure for GED_REFE_DOC_BIN using primary key. 

END dml_ged_refe_doc_bin;

/
--------------------------------------------------------
--  DDL for Package Body DML_GED_FICHE_DOC_BIN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."DML_GED_FICHE_DOC_BIN" IS

    PROCEDURE ins_ged_fiche_doc_bin (
        v_params      IN pljson,
        v_err         OUT VARCHAR2,
        v_res         OUT pljson
    )
        IS
            result   pljson := pljson ();
            
            DESDOCBI  varchar2(100)      :=   pljson_ext.get_string(v_params, 'DESDOCBI');
            EXTDOCBI  varchar2(6)        := '.pdf';
            SOUDOCBI  varchar2(100)      :=   pljson_ext.get_string(v_params, 'SOUDOCBI');
            AUTDOCBI  varchar2(100)      :=   pljson_ext.get_string(v_params, 'AUTDOCBI');
            DATDOCBI  date               :=   sysdate;
            NOMBPAGE  number             :=   TO_NUMBER(pljson_ext.get_string(v_params, 'NOMBPAGE'));
            DATEENTR  date               :=   sysdate;
            REFDOCBI  varchar2(100)      :=   pljson_ext.get_string(v_params, 'REFDOCBI');
            DATERECE  date               :=   sysdate;
            VERDOCBI  varchar2(100)      :=   pljson_ext.get_string(v_params, 'VERDOCBI');
            RESDOCBI  varchar2(100)      :=   pljson_ext.get_string(v_params, 'RESDOCBI');
            IDEDOCBI  number             :=   TO_NUMBER(pljson_ext.get_string(v_params, 'IDEDOCBI'));
            --sql_params   pljson := pljson ();
    BEGIN
        
        INSERT INTO ged_fiche_doc_bin (DESDOCBI, EXTDOCBI, SOUDOCBI, AUTDOCBI, DATDOCBI, NOMBPAGE, DATEENTR, REFDOCBI, DATERECE, VERDOCBI, RESDOCBI, IDEDOCBI)
        VALUES (DESDOCBI, EXTDOCBI, SOUDOCBI, AUTDOCBI, DATDOCBI, NOMBPAGE, DATEENTR, REFDOCBI, DATERECE, VERDOCBI, RESDOCBI, IDEDOCBI);
       
        result.put('message', 'Fiche Inserted Successfully');
        v_res := result;

        COMMIT;
    END ins_ged_fiche_doc_bin;

    PROCEDURE upd_ged_fiche_doc_bin (
        v_params      IN pljson,
        v_err         OUT VARCHAR2,
        v_res         OUT pljson
    )
        IS
    BEGIN
        --UPDATE hr.ged_fiche_doc_bin
            --SET
              --  desdocbi = in_desdocbi,
                --extdocbi = in_extdocbi,
                --soudocbi = in_soudocbi
        --WHERE
          --  idedocbi = in_idedocbi;

        COMMIT;
    END upd_ged_fiche_doc_bin;

    PROCEDURE del_ged_fiche_doc_bin (
        v_params      IN pljson,
        v_err         OUT VARCHAR2,
        v_res         OUT pljson
    )
        IS
    BEGIN
        --DELETE FROM hr.ged_fiche_doc_bin
        --WHERE
          --  idedocbi = in_idedocbi;

        COMMIT;
    END del_ged_fiche_doc_bin;

    PROCEDURE upd_datetypa_ged_fiche_doc_bin (
        v_params      IN pljson,
        v_err         OUT VARCHAR2,
        v_res         OUT pljson
    )
        IS
    BEGIN
        --UPDATE hr.ged_fiche_doc_bin
          --  SET
            --    datetypa = in_datetypa
        --WHERE
          --  idedocbi = in_idedocbi;

        COMMIT;
    END upd_datetypa_ged_fiche_doc_bin;

    PROCEDURE upd_class_ged_fiche_doc_bin (
        v_params      IN pljson,
        v_err         OUT VARCHAR2,
        v_res         OUT pljson
    )
        IS
    BEGIN
        --UPDATE hr.ged_fiche_doc_bin
          --  SET
            --    dateclas = in_dateclas,
              --  cledosar = in_cledosar
        --WHERE
          --  idedocbi = in_idedocbi;

        COMMIT;
    END upd_class_ged_fiche_doc_bin;

END dml_ged_fiche_doc_bin;

/
--------------------------------------------------------
--  DDL for Package Body DML_GED_DOC_BIN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."DML_GED_DOC_BIN" IS

    PROCEDURE ins_ged_doc_bin (
        in_lobdocbi    IN BLOB,
        out_idedocbi   OUT NUMBER
    ) IS
        result   pljson := pljson ();
    BEGIN
        INSERT INTO ged_doc_bin ( lobdocbi ) VALUES ( in_lobdocbi ) RETURNING idedocbi INTO out_idedocbi;

        COMMIT;
    END ins_ged_doc_bin;

    PROCEDURE identify_ged_doc_bin (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    ) IS

        result        pljson := pljson ();
        in_idedocbi   NUMBER := to_number(pljson_ext.get_string(v_params,'IDEDOCBI') );
        in_idclient   NUMBER := to_number(pljson_ext.get_string(v_params,'idclient') );
    BEGIN
        UPDATE hr.ged_doc_bin
            SET
                idclient = in_idclient
        WHERE
            idedocbi = in_idedocbi; -- An Id of a doc

        result.put('message','doc affected to client successfully');
        v_res := result;
        COMMIT;
    END identify_ged_doc_bin;

    PROCEDURE upd_ged_doc_bin (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    )
        IS
    BEGIN
        --UPDATE hr.ged_doc_bin
          --  SET
            --    lobdocbi = in_lobdocbi
        --WHERE
          --  idedocbi = in_idedocbi;
        COMMIT;
    END upd_ged_doc_bin;

    PROCEDURE sel_ged_docs_bin_ids (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    ) IS

        result        pljson := pljson ();
        TYPE array_of_numbers IS
            TABLE OF NUMBER;
        docs_ids      array_of_numbers;
        
        TYPE array_of_strings IS
            TABLE OF VARCHAR2(30);
        docs_names    array_of_strings;
        
        v_json_list   json_list;
        v_ids         VARCHAR2(9000) := '';
        v_names       VARCHAR2(9000) := '';
    BEGIN
        
        SELECT
            idedocbi, DESDOCBI
        BULK COLLECT INTO
            docs_ids, docs_names
        FROM
            GED_FICHE_DOC_BIN
        
        WHERE DATECLAS IS NOT NULL AND CLEDOSAR IS NOT NULL AND DATETYPA IS NOT NULL;

        FOR i IN 1..docs_ids.count LOOP
            v_ids := docs_ids(i)
            || ','
            || v_ids;
        END LOOP;
        
        FOR i IN 1..docs_names.count LOOP
            v_names := docs_names(i)
            || ','
            || v_names;
        END LOOP;
        

        result.put('ids', v_ids);
        result.put('desdocs', v_names);
        --result.put('docs_ids',json_dyn.executeobject('select IDEDOCBI from GED_DOC_BIN'));
        --result.put('message','docs ids selected Successfully');
        v_res := result;
        COMMIT;
    END sel_ged_docs_bin_ids;

    PROCEDURE sel_blob_doc_bin_by_id (
        in_idedocbi    IN NUMBER,
        out_lobdocbi   OUT BLOB
    ) IS
        result   pljson := pljson ();
    BEGIN
        SELECT
            lobdocbi
        INTO
            out_lobdocbi
        FROM
            ged_doc_bin
        WHERE
            idedocbi = in_idedocbi;

        COMMIT;
    END sel_blob_doc_bin_by_id;

    PROCEDURE sel_blob_doc_bin_by_keyword (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    ) IS

        result        pljson := pljson ();
        in_mot_cle    VARCHAR2(30) := pljson_ext.get_string(v_params,'MOT_CLE');
        TYPE array_of_numbers IS
            TABLE OF NUMBER;
        
        TYPE array_of_strings IS
            TABLE OF VARCHAR2(30);
        docs_names    array_of_strings;
        
        docs_ids      array_of_numbers;
        v_json_list   json_list;
        v_ids         VARCHAR2(9000) := '';
        v_names       VARCHAR2(9000) := '';
    BEGIN
        IF
            length(in_mot_cle) > 0
        THEN
            
            SELECT
                idedocbi
            BULK COLLECT INTO
                docs_ids
            FROM
                ged_refe_doc_bin
            WHERE
                mot_cle = in_mot_cle;

            FOR i IN 1..docs_ids.count LOOP
                v_ids := docs_ids(i)
                || ','
                || v_ids;
                
                SELECT 
                    DESDOCBI
                BULK COLLECT INTO
                    docs_names
                FROM 
                    GED_FICHE_DOC_BIN
                WHERE
                    IDEDOCBI = docs_ids(i);
                    
                FOR i IN 1..docs_names.count LOOP
                    v_names := docs_names(i)
                    || ','
                    || v_names;
                    
                END LOOP;
                
            END LOOP;
                
            result.put('ids',v_ids);
            result.put('desdocs',v_names);
            result.put('message','docs with keyword selected ');
        ELSE
            result.put('message','Saisissez un mot clé');
        END IF;

        v_res := result;
        COMMIT;
    END sel_blob_doc_bin_by_keyword;

    PROCEDURE sel_ged_doc_bin_non_type (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    ) IS
        result     pljson := pljson ();
        TYPE array_of_numbers IS
            TABLE OF NUMBER;
        docs_ids   array_of_numbers;
        
        TYPE array_of_strings IS
            TABLE OF VARCHAR2(30);
        docs_names    array_of_strings;
        
        v_ids      VARCHAR2(6000) := '';
        v_names    VARCHAR2(6000) := '';
    BEGIN
        SELECT
            idedocbi, desdocbi
        BULK COLLECT INTO
            docs_ids, docs_names
        FROM
            ged_fiche_doc_bin
        WHERE
            datetypa IS NULL;

        IF
            docs_ids.count != 0
        THEN
            FOR i IN 1..docs_ids.count LOOP
                v_ids := docs_ids(i)
                || ','
                || v_ids;
            END LOOP;
            
            FOR i IN 1..docs_names.count LOOP
                v_names := docs_names(i)
                || ','
                || v_names;
            END LOOP;

            result.put('ids',v_ids);
            result.put('desdocs',v_names);
            result.put('message','docs not typed');
        ELSE
            result.put('message','docs not typed not found');
        END IF;

        v_res := result;
        COMMIT;
    END sel_ged_doc_bin_non_type;
    
    PROCEDURE sel_ged_doc_bin_non_classe (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    ) IS
        result     pljson := pljson ();
        TYPE array_of_numbers IS
            TABLE OF NUMBER;
        docs_ids   array_of_numbers;
        
        TYPE array_of_strings IS
            TABLE OF VARCHAR2(30);
        docs_names    array_of_strings;
        
        v_ids      VARCHAR2(6000) := '';
        v_names    VARCHAR2(9000) := '';
    BEGIN
        SELECT
            idedocbi, desdocbi
        BULK COLLECT INTO
            docs_ids, docs_names
        FROM
            ged_fiche_doc_bin
        WHERE
            DATECLAS IS NULL AND CLEDOSAR IS NULL AND DATETYPA IS NOT NULL;

        IF
            docs_ids.count != 0
        THEN
            FOR i IN 1..docs_ids.count LOOP
                v_ids := docs_ids(i)
                || ','
                || v_ids;
            END LOOP;
            
            FOR i IN 1..docs_names.count LOOP
                v_names := docs_names(i)
                || ','
                || v_names;
            END LOOP;

            result.put('ids',v_ids);
            result.put('desdocs',v_names);
            result.put('message','docs not classified');
        ELSE
            result.put('message','docs not classified not found');
        END IF;

        v_res := result;
        COMMIT;
    END sel_ged_doc_bin_non_classe;
    
    PROCEDURE del_ged_doc_bin (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    )
        IS
        in_idedocbi   NUMBER := to_number(pljson_ext.get_string(v_params,'IDEDOCBI') );
        result        pljson := pljson ();
    BEGIN
        --
        DELETE FROM GED_FICHE_DOC_BIN
            WHERE
            idedocbi = in_idedocbi;
        --
        DELETE FROM GED_CARA_DOC_BIN
            WHERE
            idedocbi = in_idedocbi;
        
        --
        DELETE FROM GED_REFE_DOC_BIN
            WHERE
            idedocbi = in_idedocbi;
        
        --
        DELETE FROM GED_TYPE_DOC_BIN
            WHERE
            idedocbi = in_idedocbi;
        
        --
        DELETE FROM GED_ANN_DOC
            WHERE
            idedocbi = in_idedocbi;
        
        --
        DELETE FROM GED_DOC_BIN
            WHERE
            idedocbi = in_idedocbi;
            
        result.put('message', 'document was deleted successfully');
        v_res := result;
        
        COMMIT;
    END del_ged_doc_bin;

END dml_ged_doc_bin;

/
--------------------------------------------------------
--  DDL for Package Body DML_GED_CLIENTS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."DML_GED_CLIENTS" AS

    PROCEDURE ins_ged_clients (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    ) IS
        result        pljson            := pljson ();
        in_idedocbi   NUMBER            := to_number(pljson_ext.get_string(v_params,'IDEDOCBI') );
        stmt          VARCHAR2(32767)   := pljson_ext.get_string(v_params,'procedure');
        docname       VARCHAR2(38)      := pljson_ext.get_string(v_params,'DOCNAME');
        nom           VARCHAR2(38)      := pljson_ext.get_string(v_params,'NOM');
        prenom        VARCHAR2(38)      := pljson_ext.get_string(v_params,'PRENOM');
        l_nom         VARCHAR(20);
        l_prenom      VARCHAR(20);
        idclient              NUMBER    := 0;
        idclientSelected      NUMBER    := 0;
        nbreIds               NUMBER               := 0;
        cledosar              VARCHAR2(40)         := '';
        nbreRecordStruArch    NUMBER               := 0;
        struArch              VARCHAR2(40)         := '';
        --TYPE array_of_numbers IS TABLE OF NUMBER;
        --ids_clients array_of_numbers;
    BEGIN
                    l_prenom := LOWER(prenom);
                    l_nom := LOWER(nom);
                    -- search if the client exists initially
                    SELECT
                        COUNT(IDCLIENT)
                    INTO
                        nbreIds
                    FROM
                        ged_clients
                    where
                        PRENOM=l_prenom AND NOM=l_nom;
                    
            IF
                length(l_nom) > 0 AND length(l_prenom) > 0 AND length(docname) > 0
            THEN
                IF 
                    nbreIds = 1
                THEN
                    SELECT
                        IDCLIENT
                    INTO
                        idclientSelected
                    FROM
                        ged_clients
                    where
                        PRENOM=l_prenom AND NOM=l_nom;
                
                    --Identification du document
                    EXECUTE IMMEDIATE 'UPDATE ged_doc_bin SET idclient = :idclientSelected WHERE idedocbi = :in_idedocbi'
                    USING idclientSelected,in_idedocbi;
                    result.put('message1','doc identified successfully');
                    --Classement du document
                    cledosar := l_nom || '#' || idclientSelected || ':' || docname;
                    struArch := l_nom || '#' || idclientSelected;
                    EXECUTE IMMEDIATE 'UPDATE ged_fiche_doc_bin SET CLEDOSAR = :cledosar WHERE idedocbi = :in_idedocbi'
                    USING cledosar,in_idedocbi;
                    EXECUTE IMMEDIATE 'UPDATE ged_fiche_doc_bin SET DATECLAS = SYSDATE WHERE idedocbi = :in_idedocbi'
                    USING in_idedocbi;
                    result.put('idClient',idclientSelected);
                    
                        SELECT COUNT(IDENDOSS) 
                        INTO nbreRecordStruArch FROM GED_STRUCTURE_ARCH WHERE IDENDOSS=struArch;
                        
                        IF 
                             nbreRecordStruArch = 0 
                        THEN
                            EXECUTE IMMEDIATE 'INSERT INTO GED_STRUCTURE_ARCH ( IDENDOSS, DESIDOSS, TYPEDOSS ) VALUES (:idendoss, :desidoss, :typedoss)'
                            USING struArch, struArch, 'S';
                        ELSE
                            result.put('message','structure archive exists');                            
                        END IF;
                    
                ELSIF
                    nbreIds = 0 
                THEN
                    IF
                        length(stmt) > 42
                    THEN
                            --Identification du document
                        EXECUTE IMMEDIATE stmt || ' returning IDCLIENT into :idclient' RETURNING INTO
                        idclient; -- 42 characters
                        EXECUTE IMMEDIATE 'UPDATE ged_doc_bin SET idclient = :idclient WHERE idedocbi = :in_idedocbi'
                        USING idclient,in_idedocbi;
                            --Classement du document
                        cledosar := l_nom || '#' || idclient || ':' || docname;
                        struArch := l_nom || '#' || idclient;
                        EXECUTE IMMEDIATE 'UPDATE ged_fiche_doc_bin SET CLEDOSAR = :cledosar WHERE idedocbi = :in_idedocbi'
                        USING cledosar,in_idedocbi;
                        EXECUTE IMMEDIATE 'UPDATE ged_fiche_doc_bin SET DATECLAS = SYSDATE WHERE idedocbi = :in_idedocbi'
                        USING in_idedocbi;
                        result.put('idClient',idclient);
                        
                        SELECT COUNT(IDENDOSS) 
                        INTO nbreRecordStruArch FROM GED_STRUCTURE_ARCH WHERE IDENDOSS=struArch;
                        
                        IF 
                             nbreRecordStruArch = 0
                        THEN
                            EXECUTE IMMEDIATE 'INSERT INTO GED_STRUCTURE_ARCH ( IDENDOSS, DESIDOSS, TYPEDOSS ) VALUES (:idendoss, :desidoss, :typedoss)'
                            USING struArch, struArch, 'S';
                        ELSE
                            result.put('message','structure archive exists');                            
                        END IF;                        
                    
                    ELSE
                        result.put('messageError','ERROR STMT');
                    END IF;
                ELSE
                    result.put('messageError','Multiple clients with same name');
                END IF;
                
            ELSE
                result.put('messageError','ERROR FIELD WHITHOUT VALUE');
            END IF;
        
        result.put('messageEND','Procedure end');
        result.put('numberFound',nbreIds);
        v_res := result;
        COMMIT;
    END ins_ged_clients;
    
    PROCEDURE select_fields_clients (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    ) IS
        result       pljson := pljson ();
        sql_params   pljson := pljson ();
    BEGIN
        sql_params.put('table_name','GED_CLIENTS');
        result.put('fieldsClient',json_dyn.executeobject('select column_name from all_tab_columns where table_name = :table_name',sql_params
) );
        v_res := result;
        COMMIT;
    END select_fields_clients;

END dml_ged_clients;

/
--------------------------------------------------------
--  DDL for Package Body DML_GED_CARA_DOC_BIN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."DML_GED_CARA_DOC_BIN" IS

    PROCEDURE ins_ged_cara_doc_bin (
        v_params      IN pljson,
        v_err         OUT VARCHAR2,
        v_res         OUT pljson
    )
        IS
        result   pljson := pljson ();
        IDEDOCBI  number                   :=    TO_NUMBER(pljson_ext.get_string(v_params, 'IDEDOCBI'));
        CODECARA  varchar2(30)             :=    pljson_ext.get_string(v_params, 'CODECARA');
        LIBECARA  varchar2(100)             :=    pljson_ext.get_string(v_params, 'LIBECARA');
        
    BEGIN
        INSERT INTO hr.ged_cara_doc_bin (
            IDEDOCBI,
            CODECARA,
            LIBECARA
        ) VALUES (
            IDEDOCBI,
            CODECARA,
            LIBECARA
        );
        result.put('message', 'Doc Caracterised Successfully');
        v_res := result;
        COMMIT;
    END ins_ged_cara_doc_bin;

  -- No Primary Key!  Cannot create UPDATE procedure for GED_CARA_DOC_BIN using primary key. 

  -- No Primary Key!  Cannot create DELETE procedure for GED_CARA_DOC_BIN using primary key. 

END dml_ged_cara_doc_bin;

/
--------------------------------------------------------
--  DDL for Package Body DML_GED_CARA
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."DML_GED_CARA" AS
PROCEDURE select_caracs_chosen_type (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    ) IS
            result   pljson := pljson ();            
            sql_params   pljson := pljson ();
    BEGIN
    
        sql_params.put('IDETYPDO', pljson_ext.get_string(v_params, 'idTypeChosen'));
        result.put('caras',json_dyn.executeobject('select CODECARA, VALECARA from ged_cara where IDETYPDO = :IDETYPDO', sql_params));
        v_res := result;
    
    COMMIT;
    END select_caracs_chosen_type;
END DML_GED_CARA;

/
--------------------------------------------------------
--  DDL for Package Body DML_GED_ANN_TYPE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."DML_GED_ANN_TYPE" AS

    PROCEDURE sel_ged_ann_type (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    ) IS
        result   pljson := pljson ();
    BEGIN
        result.put('typeAnno',json_dyn.executeobject('select CODETYPAN from ged_ann_type') );
        v_res := result;
        COMMIT;
    END sel_ged_ann_type;

END dml_ged_ann_type;

/
--------------------------------------------------------
--  DDL for Package Body DML_GED_ANN_DOC
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HR"."DML_GED_ANN_DOC" IS

    PROCEDURE ins_ged_ann_doc (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    ) IS

        result         pljson := pljson ();
        in_codetypan   VARCHAR2(30) := pljson_ext.get_string(v_params,'CODETYPAN');
        in_textanno    VARCHAR2(300) := pljson_ext.get_string(v_params,'TEXTANNO');
        in_idedocbi    NUMBER := 0;
        in_dateanno    DATE := SYSDATE;
    BEGIN
        IF
            length(in_textanno) > 0 AND length(in_codetypan) > 0
        THEN
            in_idedocbi := to_number(pljson_ext.get_string(v_params,'IDEDOCBI') );
            INSERT INTO ged_ann_doc (
                idedocbi,
                codetypan,
                textanno,
                dateanno
            ) VALUES (
                in_idedocbi,
                in_codetypan,
                in_textanno,
                in_dateanno
            );
            result.put('message','doc annotated successfully');
        ELSE
            result.put('message','doc not annotated');
        END IF;

        
        v_res := result;
        COMMIT;
    END ins_ged_ann_doc;

    PROCEDURE sel_ged_ann_doc_id (
        v_params   IN pljson,
        v_err      OUT VARCHAR2,
        v_res      OUT pljson
    )
        IS
        
        result         pljson := pljson ();
        in_idedocbi    NUMBER := 0;
        sql_params   pljson := pljson ();
    BEGIN
        
        --in_idedocbi := to_number(pljson_ext.get_string(v_params,'IDEDOCBI')); -- Id of doc
        
        sql_params.put('IDEDOCBI', to_number(pljson_ext.get_string(v_params,'IDEDOCBI')));
        
        result.put('annoDocs',json_dyn.executeobject('SELECT
            DESDOCBI, TEXTANNO, DATEANNO, CODETYPAN
            FROM 
            GED_ANN_DOC
            INNER JOIN GED_FICHE_DOC_BIN ON
            GED_FICHE_DOC_BIN.IDEDOCBI = :IDEDOCBI AND GED_ANN_DOC.IDEDOCBI = :IDEDOCBI', sql_params) );
        
        /*
            SELECT
                DESDOCBI, TEXTANNO, DATEANNO
            FROM
                GED_ANN_DOC
            INNER JOIN GED_FICHE_DOC_BIN ON
                GED_FICHE_DOC_BIN.IDEDOCBI = in_idedocbi AND GED_ANN_DOC.IDEDOCBI = in_idedocbi;
        
        */
        v_res := result;
        COMMIT;
    END sel_ged_ann_doc_id;

  -- No Primary Key!  Cannot create UPDATE procedure for GED_ANN_DOC using primary key.

  -- No Primary Key!  Cannot create DELETE procedure for GED_ANN_DOC using primary key.

END dml_ged_ann_doc;

/
--------------------------------------------------------
--  DDL for Synonymn DBMS_LOB
--------------------------------------------------------

  CREATE OR REPLACE PUBLIC SYNONYM "DBMS_LOB" FOR "SYS"."DBMS_LOB";
--------------------------------------------------------
--  DDL for Synonymn DBMS_OUTPUT
--------------------------------------------------------

  CREATE OR REPLACE PUBLIC SYNONYM "DBMS_OUTPUT" FOR "SYS"."DBMS_OUTPUT";
--------------------------------------------------------
--  DDL for Synonymn HTP
--------------------------------------------------------

  CREATE OR REPLACE PUBLIC SYNONYM "HTP" FOR "SYS"."HTP";
--------------------------------------------------------
--  DDL for Synonymn PLITBLM
--------------------------------------------------------

  CREATE OR REPLACE PUBLIC SYNONYM "PLITBLM" FOR "SYS"."PLITBLM";
--------------------------------------------------------
--  DDL for Synonymn UTL_ENCODE
--------------------------------------------------------

  CREATE OR REPLACE PUBLIC SYNONYM "UTL_ENCODE" FOR "SYS"."UTL_ENCODE";
--------------------------------------------------------
--  DDL for Synonymn UTL_RAW
--------------------------------------------------------

  CREATE OR REPLACE PUBLIC SYNONYM "UTL_RAW" FOR "SYS"."UTL_RAW";
--------------------------------------------------------
--  DDL for Synonymn NLS_SESSION_PARAMETERS
--------------------------------------------------------

  CREATE OR REPLACE PUBLIC SYNONYM "NLS_SESSION_PARAMETERS" FOR "SYS"."NLS_SESSION_PARAMETERS";
--------------------------------------------------------
--  DDL for Synonymn OWA_UTIL
--------------------------------------------------------

  CREATE OR REPLACE PUBLIC SYNONYM "OWA_UTIL" FOR "SYS"."OWA_UTIL";
--------------------------------------------------------
--  DDL for Synonymn JSON
--------------------------------------------------------

  CREATE OR REPLACE SYNONYM "HR"."JSON" FOR "HR"."PLJSON";
--------------------------------------------------------
--  DDL for Synonymn JSON_DYN
--------------------------------------------------------

  CREATE OR REPLACE SYNONYM "HR"."JSON_DYN" FOR "HR"."PLJSON_DYN";
--------------------------------------------------------
--  DDL for Synonymn JSON_LIST
--------------------------------------------------------

  CREATE OR REPLACE SYNONYM "HR"."JSON_LIST" FOR "HR"."PLJSON_LIST";
--------------------------------------------------------
--  DDL for Synonymn DBMS_SQL
--------------------------------------------------------

  CREATE OR REPLACE PUBLIC SYNONYM "DBMS_SQL" FOR "SYS"."DBMS_SQL";
