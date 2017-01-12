## Image Uploader using HTML5 FileReader

A brief tutorial uses a combination of Hyperloop native and JavaScript code to implement an image uploader with preview.

The steps involved are:

  - define an image file input html code and an `onchange` function to call
  - define the `onchange` function
  - define check functions to see if
    - FileReader feature is supported by the browser
    - Image file is of an accepted file type
    - Image file is of an accepted size
  - define `onload` function to determine what should be done when the image is completely loaded

##### Define Image File HTML

The `input` html form element is used with type: `file` to load the image file. Its display style could be set to `none` not to show the conventional file input UI. When this is included has a child within a `label` element, the label can be clicked to launch the file selection box. To upload only a single image file, `multiple` option should be set to `false`.

To set an action to perform when an image file is selected, the `on(:change)`  method is changed to the file input element. This calls the onChange function that processes the image file.

The image preview requires a `img` element to update later when the image file is full loaded. A prepositioned image element can be placed with the initial html or it could be generated on the fly and inserted after uploading the image file. A prepositioned image element is used here.

`img(class: "picture candidate", id: "resume-picture", src: state.data_uri)`

And it's `src` attribute could be set using different strategies. An option embraced here is setting it to `state.data_uri` initialized under before_mount and updated by a processig function when the image file is fully uploaded.

```ruby
before_mount
  state.data_uri! ""
end

div(class: "user-picture large-3 small-12 columns") do
  div(id: "my_result")
  img(class: "picture candidate", id: "resume-picture", src: state.data_uri)
  if(val_edit_mode == "true")
    em() do
      label(class: "btn", htmlFor: :picture, style: {textAlign: "center"}) do
        i(class: "fi-upload")
        if(state.data_uri == "")
          span{" Upload Picture"}
        else
          span{" Change Picture"}
        end
        input(type: "file", id: :picture, multiple: false, style: {display: :none}).on(:change) do |e|
          handle_files(e)
        end
      end
    end
  end
end
```

##### Define the onChange function to handle selected file and perform checks

The onChange function `handle_files(e)`called from the image input hmtl should carry out pre-checks before finally loading the image file.

```ruby
def handle_files(e)
  alert('your browser is not supported') && return if `typeof(FileReader) == 'undefined'`
  file = e.target.files[0]
  return unless validate_file(file)
  ### continue after validating file meets specifications
end
```

The first check is to see if the [HTML5 Canvas FileReader][FileReader] function is supported by the user browser. Further checks are carried out (`validate_file()`) to ensure the file is of acceptable type and size. File type could also be restricted by specifying [HTML accept][input_accept] attribute on the input.

```ruby
VALID_FORMATS = %w(jpg jpeg png)
MAX_SIZE = 1048576

def validate_file(file)
  if !VALID_FORMATS.include?(`#{file.name}`.split('.').last.downcase)
    alert("... gotta use #{VALID_FORMATS} ")
  elsif `#{file.size}` > MAX_SIZE
    alert(" file is too big ")
  else
    return true
  end
  nil
end
```

Once all validations are done the FileReader object is instantiated with the FileList from input HTML

```ruby
def handle_files(e)
  alert('your browser is not supported') && return if `typeof(FileReader) == 'undefined'`
  file = e.target.files[0]
  return unless validate_file(file)
  image_holder = Element['img#resume-picture']
  image_holder.empty
  image_holder.show

  reader = `new FileReader()`
  `reader.onload = function(upload) { #{upload_complete(`upload`)} }`
  `reader.readAsDataURL(#{file.to_n})`
end

def upload_complete(upload)
  state.data_uri! `upload.target.result`
end
```

The `onload` function could be used to carry out any post processing functions such as image reduction, storing files or updating other records. If not needed, `#{upload_complete(`upload`)}` could just be reduced to a single statement ` state.data_uri! `upload.target.result` `.

 [FileReader]:<https://developer.mozilla.org/en/docs/Web/API/FileReader>
 [input_accept]:<http://www.w3schools.com/tags/att_input_accept.asp>
