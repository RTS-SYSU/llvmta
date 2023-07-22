#include <iostream>
#include <fstream>
#include <string>
#include <list>
using namespace std;

list<string> openHEXAndRetriveInstructions( char* argname )
{
    //read the file and put instructions in the list 'instructions'
    list<string> instructions;
    ifstream source_file;
    string filename = string(argname) + ".hex";
    source_file.open( filename.c_str() , ios::in );

    if( source_file.is_open() )
    {
      list<string> list_of_strings;
      string line;
      int j=0;

      while( getline( source_file , line ) )
        list_of_strings.push_back( line.substr( 9 , line.length()-2-9-1 ) );

      //to remove the last 2 lines, they don't contain any instruction
      list_of_strings.pop_back();
      list_of_strings.pop_back();

      for(  list<string>::iterator it=list_of_strings.begin() ;
            it != list_of_strings.end() ;
            it++ )
      {
          int numOfInstr = (*it).length() / 8;

          for( int j=0, k=0 ; j<numOfInstr ; j++, k+=8 )
          {
              string s0 = (*it);
              string s1 = s0.substr(k,8);
              instructions.push_back( s1 );
          }
      }

      source_file.close();
  }
  else
    cout << "impossible to open: " + filename + "\n";

  return instructions;
}

void createMIFAndWriteInstructions( char* argname , list<string> instructions )
{
    //create the .mif and put the instructions in it
    string destfile_name = string(argname) + ".mif";
    ofstream destination_file( destfile_name.c_str() );

    if( destination_file.is_open() )
    {
        destination_file << "WIDTH=32;" << endl;
        destination_file << "DEPTH=65536;" << endl;
        destination_file << "ADDRESS_RADIX=DEC;" << endl;
        destination_file << "DATA_RADIX=HEX;" << endl;
        destination_file << "CONTENT BEGIN" << endl;

        int k=0;
        for(  list<string>::iterator it=instructions.begin() ;
              it != instructions.end() ;
              it++, k++ )
        {
            string line= to_string(k) + ":" + (*it) + ";";
            destination_file << line << endl;
        }

        destination_file << "["+to_string(k)+"..65535] : 0;" << endl;
        destination_file << "END;";

        destination_file.close();
    }
    else
      cout << "impossible to write: " + destfile_name + "\n";
}

int main( int argc, char* argv[] ) {
  if( argc > 1 )
  {
    for( int i=1 ; i<argc ; i++ )
    {
        list<string> instructions = openHEXAndRetriveInstructions( argv[1] );
        createMIFAndWriteInstructions( argv[1] , instructions );
      }
  }
  else
  {
    cout << "usage: hex2mif <namefile> (where namefile is the name of a hex file)" << endl;
    cout << "       DON'T put the extension in the namefile" << endl;
  }

  return 0;
}
