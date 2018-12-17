# public record magick
Access to public records can be limited by policies designed to minimize access such as no copies or access only for limited amounts of time at specified locations. This script helps automate the creation of text searchable pdf files from digital photos of documents. (best results with a high resolution camera)

This was used sucessfully to aid in a dispute in LA.

## use
Move folder with all .IMG files into public-recorder directory.

```bash
./run.sh <img-dir>
```


## dependencies
- imagemagick
- pypdfocr
