program AbsensiV1App;
uses crt;

//Deklarasi

type DataMhs = record
                 NIM : longint;   {NIM Mahasiswa Maksimal Panjang 8 Agar Tidak Merusak Layout}
                 Nama : string[25]; {Nama Mahasiswa Maksimal 25}
                 Abs : array[1..10] of Char; {Absensi Untuk Setiap Pertemuan}
                 Nrekap : integer;    {Nilai Rekapitulasi}
               end;

     //Type Untuk Arsip
     ArsipData = File of DataMhs;

     //Type Untuk Pengurutan Data
     ArrayMhs = array[1..100] of DataMhs;

var
  menu : integer; {Untuk Pilihan Menu}
  menu1 : integer; {Untuk Pilihan Sub Menu}
  opsi : char; {Untuk Pilihan Opsi [Y/N]}

  Data : ArsipData; {Peubah Untuk Menampung Pembacaan Data}
  CariNIM : longint; {Untuk Pencarian Data}

  L : ArrayMhs; {Peubah Untuk Pengurutan Data}

  n : integer;
  i : integer;
  Minggu : integer; {indeks untuk pertemuan}

  //Menu 1 Rekam Data
  {Procedure Rekam Data Mahasiswa}
  procedure RekamDataMhs(var data : ArsipData);
  var
    Mhs : DataMhs;
  begin
    assign(data, 'data.dat');
    rewrite(data);

    for i:= 1 to N do
    begin
      gotoxy(1,4+i);writeln(i);
      gotoxy(5,4+i);readln(Mhs.NIM);
      gotoxy(16,4+i);readln(Mhs.Nama);
      write(data, mhs);
      writeln;
    end;
    close(data);
    gotoxy(1,n+7);writeln('Data Telah Berhasil Dibuat');
  end;

  //Menu 2  Tambah Data
  {Procedure Tambah Data}
  procedure TambahDataMhs(var data : ArsipData);
  var
    Mhs : DataMhs;
    temp : ArsipData;
  begin
    assign(data, 'data.dat');
    reset(data);

    assign(temp, 'temp.dat');
    rewrite(temp);

    while not EOF(data) do
    begin
      read(data, Mhs);
      write(temp, Mhs);
    end;
    close(data);

    for i:=1 to N do
    begin
      write('NIM  : ');readln(Mhs.NIM);
      write('Nama : ');readln(Mhs.Nama);
      write(temp,Mhs);
      writeln();
    end;
    close(temp);

   assign(data, 'data.dat');
   rewrite(data);

   assign(temp, 'temp.dat');
   reset(temp);

   while not EOF(temp) do
   begin
     read(temp, Mhs);
     write(data, Mhs);
   end;

   close(temp);
   close(data);
   writeln('Telah Berhasil Menambah Data');
  end;

  //Menu 3 Lihat Data & Sort
  {Procedure Lihat Data Mahasiswa}
  procedure CetakDataMhs(var data : ArsipData);
  var
    Mhs : DataMhs;
  begin
    assign(data, 'data.dat');
    reset(data);
    i:=1;
    while not EOF(data) do
    begin
      read(data, mhs);
      gotoxy(1,5+i);writeln(Mhs.NIM);
      gotoxy(12,5+i);writeln(Mhs.Nama);
      i:=i+1;
      writeln;
    end;
    close(data);
  end;

  procedure SalinData(var data : ArsipData; var L : ArrayMhs; var n : integer); {Salin Data}
  var
    Mhs : DataMhs;
  begin
    assign(data, 'data.dat');
    reset(data);

    n:=0;
    while not EOF(data) do
    begin
      read(data, mhs);
      n:=n+1;
      L[n]:=mhs;
    end;
    close(data);
  end;

  procedure SortData(var L : ArrayMhs; n : integer); {Sort Data}
  var
    imaks, i, j : integer;
    temp : DataMhs;
  begin
    for i:=n downto 2 do
    begin
      imaks:=1;
      for j:=2 to i do
      begin
        if L[J].NIM > L[imaks].NIM then
        begin
          imaks:=J;
        end;
      end;
      temp:=L[i];
      L[i]:=L[imaks];
      L[imaks]:=temp;
    end;
  end;

  procedure SalinLarikData(L : ArrayMhs; n : integer; var data : ArsipData); {Salin Larik Ke Data}
  var
    i : integer;
  begin
    assign(data, 'data.dat');
    rewrite(data);
    for i:=1 to n do
    begin
      write(data, L[i]);
    end;
    close(data);
  end;

  {Perbaiki Data}
  procedure PerbaikiDataNIM(var data : ArsipData; CariNIM : longint);
  var
    Mhs : DataMhs;
    Temp : ArsipData;
    ketemu : boolean;
    NIMBaru : longint;
  begin
    assign(data, 'data.dat');
    reset(data);

    assign(temp, 'temp.dat');
    rewrite(temp);

    ketemu:=false;

    while (not ketemu) and (not EOF(data)) do
    begin
      read(data, mhs);
      if(mhs.nim = cariNIM) then
        ketemu:=true
      else
      write(temp, mhs);
    end;

    if ketemu then
    begin
      writeln('=====================================');
      writeln('            NIM DITEMUKAN            ');
      writeln('-------------------------------------');
      writeln('NIM      : ',mhs.NIM);
      writeln('Nama     : ',mhs.Nama);
      writeln('-------------------------------------');
      write('NIM Baru : ');readln(NIMBaru);
      mhs.NIM:=NIMBaru;
      write(temp, mhs);
      while (not EOF(data)) do
      begin
        read(data, mhs);
        write(temp, mhs);
      end;
    end
    else
      writeln('NIM TIDAK DITEMUKAN!');
    close(data);
    close(temp);

    assign(temp, 'temp.dat');
    reset(temp);

    assign(data, 'data.dat');
    rewrite(data);
    while not EOF(temp) do
    begin
      read(temp, mhs);
      write(data, mhs);
    end;
    close(temp);
    close(data);
  end;

  procedure PerbaikiDataNAMA(var data : ArsipData; CariNIM : longint);
  var
    Mhs : DataMhs;
    Temp : ArsipData;
    ketemu : boolean;
    NamaBaru : string[25];
  begin
    assign(data, 'data.dat');
    reset(data);

    assign(temp, 'temp.dat');
    rewrite(temp);

    ketemu:=false;

    while (not ketemu) and (not EOF(data)) do
    begin
      read(data, mhs);
      if(mhs.nim = cariNIM) then
        ketemu:=true
      else
      write(temp, mhs);
    end;

    if ketemu then
    begin
      writeln('=====================================');
      writeln('            NIM DITEMUKAN            ');
      writeln('-------------------------------------');
      writeln('NIM      : ',mhs.NIM);
      writeln('Nama     : ',mhs.Nama);
      writeln('-------------------------------------');
      write('Nama Baru : ');readln(NamaBaru);
      mhs.Nama:=NamaBaru;
      write(temp, mhs);
      while (not EOF(data)) do
      begin
        read(data, mhs);
        write(temp, mhs);
      end;
    end
    else
      writeln('NIM TIDAK DITEMUKAN!');
    close(data);
    close(temp);

    assign(temp, 'temp.dat');
    reset(temp);

    assign(data, 'data.dat');
    rewrite(data);
    while not EOF(temp) do
    begin
      read(temp, mhs);
      write(data, mhs);
    end;
    close(temp);
    close(data);
  end;


  //Menu 4
  {Isi Absensi}

  procedure Absensi(var data : ArsipData);
  var
    Mhs : DataMhs;
    Temp : ArsipData;
  begin
    assign(data, 'data.dat');
    reset(data);

    assign(temp, 'temp.dat');
    rewrite(temp);

    i:=0;
    repeat
      read(data, mhs);
      gotoxy(1,4+i);writeln(mhs.NIM);
      gotoxy(12,4+i);writeln(mhs.Nama);
      gotoxy(40, 4+i);write('Kehadiran [H/S/I/A] : ');readln(Mhs.Abs[Minggu]);
      Mhs.Abs[Minggu]:=upcase(Mhs.Abs[Minggu]);
      write(temp, mhs);
      i:=i+1;
    until EOF(data);

    close(data);
    close(temp);

    assign(temp, 'temp.dat');
    reset(temp);

    assign(data, 'data.dat');
    rewrite(data);
    while not EOF(temp) do
    begin
      read(temp, mhs);
      write(data, mhs);
    end;
    close(temp);
    close(data);
  end;

  //Menu 5
   procedure UbahNilaiAbsensi(var data : ArsipData);
  var
    Mhs : DataMhs;
    Temp : ArsipData;
    nilai_abs : Array[1..10] of longint;
  begin
    assign(data, 'data.dat');
    reset(data);

    assign(temp, 'temp.dat');
    rewrite(temp);
    repeat
      read(data, mhs);
      for minggu:=1 to 10 do
      begin
        case (Mhs.Abs[Minggu]) of
        'H' : nilai_abs[Minggu] := 10;
        'S' : nilai_abs[Minggu] := 0;
        'I' : nilai_abs[Minggu] := 0;
        'A' : nilai_abs[Minggu] := 0;
        else nilai_abs[Minggu] := 0;
        end;
      end;
      mhs.Nrekap:=0;
      for minggu:=1 to 10 do
      begin
        mhs.Nrekap:=mhs.Nrekap+nilai_abs[minggu];
      end;
      write(temp, mhs);
    until EOF(data);
    close(data);
    close(temp);
    assign(temp, 'temp.dat');
    reset(temp);
    assign(data, 'data.dat');
    rewrite(data);
    while not EOF(temp) do
    begin
      read(temp, mhs);
      write(data, mhs);
    end;
    close(temp);
    close(data);
  end;

  procedure CetakAbsen(var data : ArsipData);
  var
    mhs : DataMhs;
  begin
    assign(data, 'data.dat');
    reset(data);
    i:=0;
    while not EOF(data) do
    begin
      read(data, mhs);
      for minggu:=1 to 10 do
      begin
        if mhs.abs[minggu]='H' then mhs.abs[minggu]:='H'
        else if mhs.abs[minggu]='S' then mhs.abs[minggu]:='S'
        else if mhs.abs[minggu]='I' then mhs.abs[minggu]:='I'
        else if mhs.abs[minggu]='A' then mhs.abs[minggu]:='A'
        else mhs.abs[minggu]:=' ';
      end;
      gotoxy(1,6+i);writeln(mhs.nim);
      gotoxy(12,6+i);writeln(mhs.nama);
      gotoxy(40,6+i);writeln(mhs.abs[1]);
      gotoxy(43,6+i);writeln(mhs.abs[2]);
      gotoxy(46,6+i);writeln(mhs.abs[3]);
      gotoxy(50,6+i);writeln(mhs.abs[4]);
      gotoxy(53,6+i);writeln(mhs.abs[5]);
      gotoxy(56,6+i);writeln(mhs.abs[6]);
      gotoxy(59,6+i);writeln(mhs.abs[7]);
      gotoxy(62,6+i);writeln(mhs.abs[8]);
      gotoxy(65,6+i);writeln(mhs.abs[9]);
      gotoxy(68,6+i);writeln(mhs.abs[10]);
      gotoxy(72,6+i);writeln(mhs.Nrekap,'%');
      i:=i+1;
    end;
    writeln;
    writeln('============================================================================');
    close(data);
  end;


//Program Utama
begin
  repeat
    writeln('================================================');
    writeln('                APLIKASI ABSENSI                ');
    writeln('------------------------------------------------');
    writeln('1. Buat Data Arsip Mahasiswa');
    writeln('2. Tambah Data Baru Mahasiswa');
    writeln('3. Lihat Data Mahasiswa');
    writeln('4. Isi Absensi');
    writeln('5. Lihat Rekapitulasi Absensi');
    writeln('6. Keluar');
    gotoxy(1,11);writeln('------------------------------------------------');
    gotoxy(1,13);writeln('================================================');
    gotoxy(1,12);write('Masukkan Pilihan Menu (1-6) : ');readln(menu);
    clrscr;
    case menu of
    //Buat Arsip Mahasiswa
    1 : begin
          repeat
            writeln('-----------------------------------------------------');
            writeln('--------------------PERINGATAN!!!--------------------');
            writeln('-----------------------------------------------------');
            writeln('Anda Akan Membuat Data Baru & Data Lama Akan Terhapus');
            gotoxy(1,6);writeln('=====================================================');
            gotoxy(1,5);write('Lanjut [Y/N] : ');readln(opsi);
            opsi:=upcase(opsi);
            clrscr;
            if (opsi='Y') then
            begin
              write('Berapa Banyak Data Yang Akan Dibuat ? ');readln(N);
              clrscr;
              gotoxy(1,1);writeln('Tekan <Enter> Untuk Berpindah');
              gotoxy(1,2);writeln('==========================================');
              gotoxy(1,3);writeln('NO');
              gotoxy(5,3);writeln('NIM');
              gotoxy(16,3);writeln('Nama');
              gotoxy(1,4);writeln('------------------------------------------');
              RekamDataMhs(data);
              gotoxy(1,n+6);writeln('==========================================');
            end;
            if (opsi='N') then
            begin
              writeln('Dibatalkan...');
            end;
          until (opsi='Y') or (opsi='N');
        readkey;
        clrscr;
        end;
    //Tambah Data Baru
    2 : begin
          write('Berapa Banyak Data Yang Akan Ditambah ? ');readln(n);
          TambahDataMhs(data);
        readkey;
        clrscr;
        end;
    //Lihat Data Mahasiswa
    3 : begin
          SalinData(data, L, n);
          if n=0 then
          begin
               write('BELUM ADA DATA MAHASISWA');
          end
          else
          begin
            SortData(L, n);
            SalinLarikData(L, n, data);
            gotoxy(1,1);writeln('==========================================');
            gotoxy(1,2);writeln('             DAFTAR MAHASISWA             ');
            gotoxy(1,3);writeln('------------------------------------------');
            gotoxy(1,4);writeln('NIM');
            gotoxy(12,4);writeln('Nama');
            gotoxy(1,n+7);writeln('==========================================');
            CetakDataMhs(data);
            gotoxy(1,n+9);write('Apakah Ada Data Yang Ingin Diubah? [Y/N] ');readln(opsi);
            writeln;
            opsi:=upcase(opsi);
            if opsi='Y' then
            begin
              writeln('1. NIM');
              writeln('2. Nama');
              write('Apa Yang Ingin Diubah ? ');readln(menu1);
              clrscr;
              case menu1 of
              1 : begin
                    write('Masukkan NIM : ');readln(CariNIM);
                    writeln;
                    PerbaikiDataNIM(data, CariNIM);
                  end;
              2 : begin
                    write('Masukkan NIM : ');readln(CariNIM);
                    PerbaikiDataNAMA(data, CariNim);
                  end;
              end;
            end
            else writeln('Tekan Sembarang Untuk Lanjut...');
          end;
        readkey;
        clrscr;
        end;
    //Isi Absensi
    4 : begin
          if n=0 then
          begin
            writeln('====================================================');
            writeln('              Belum Ada Data Mahasiswa              ');
            writeln('Atau Buka Menu LIHAT DATA MAHASISWA Terlebih Dahulu!');
            writeln('====================================================');
            readkey;
          end
          else
          begin
          repeat
            writeln('=====================================================');
            writeln('                ISI ABSENSI MAHASISWA                ');
            writeln('-----------------------------------------------------');
            writeln('1.  Pertemuan Pertama');
            writeln('2.  Pertemuan Kedua');
            writeln('3.  Pertemuan Ketiga');
            writeln('4.  Pertemuan Keempat');
            writeln('5.  Pertemuan Kelima');
            writeln('6.  Pertemuan Keenam');
            writeln('7.  Pertemuan Ketujuh');
            writeln('8.  Pertemuan Kedelapan');
            writeln('9.  Pertemuan Kesembilan');
            writeln('10. Pertemuan Sepuluh');
            writeln('11. Kembali');
            writeln('-----------------------------------------------------');
            gotoxy(1,17);writeln('=====================================================');
            gotoxy(1,16);write('Masukkan Pilihan (1-11) : ');readln(menu1);
            clrscr;
            case menu1 of
            1 : begin
                  writeln('Absensi Pertemuan 1');
                  writeln('-------------------------------------------------------------------');
                  Minggu:=1;
                  Absensi(data);
                readkey;
                clrscr;
                end;
            2 : begin
                  writeln('Absensi Pertemuan 2');
                  writeln('-------------------------------------------------------------------');
                  Minggu:=2;
                  Absensi(data);
                readkey;
                clrscr;
                end;
            3 : begin
                  writeln('Absensi Pertemuan 3');
                  writeln('-------------------------------------------------------------------');
                  Minggu:=3;
                  Absensi(data);
                readkey;
                clrscr;
                end;
            4 : begin
                  writeln('Absensi Pertemuan 4');
                  writeln('-------------------------------------------------------------------');
                  Minggu:=4;
                  Absensi(data);
                readkey;
                clrscr;
                end;
            5 : begin
                  writeln('Absensi Pertemuan 5');
                  writeln('-------------------------------------------------------------------');
                  Minggu:=5;
                  Absensi(data);
                readkey;
                clrscr;
                end;
            6 : begin
                  writeln('Absensi Pertemuan 6');
                  writeln('-------------------------------------------------------------------');
                  Minggu:=6;
                  Absensi(data);
                readkey;
                clrscr;
                end;
            7 : begin
                  writeln('Absensi Pertemuan 7');
                  writeln('-------------------------------------------------------------------');
                  Minggu:=7;
                  Absensi(data);
                readkey;
                clrscr;
                end;
            8 : begin
                  writeln('Absensi Pertemuan 8');
                  writeln('-------------------------------------------------------------------');
                  Minggu:=8;
                  Absensi(data);
                readkey;
                clrscr;
                end;
            9 : begin
                  writeln('Absensi Pertemuan 9');
                  writeln('-------------------------------------------------------------------');
                  Minggu:=9;
                  Absensi(data);
                readkey;
                clrscr;
                end;
            10 : begin
                   writeln('Absensi Pertemuan 10');
                  writeln('-------------------------------------------------------------------');
                  Minggu:=10;
                  Absensi(data);
                 readkey;
                 clrscr;
                 end;
            end;
          until menu1=11;
          end;
          writeln('Tekan Sembarang Untuk Lanjut...');
        readkey;
        clrscr;
        end;
    //Lihat Rekapitulasi Absensi
    5 : begin
          if n=0 then
          begin
            writeln('====================================================');
            writeln('              Belum Ada Data Mahasiswa              ');
            writeln('Atau Buka Menu LIHAT DATA MAHASISWA Terlebih Dahulu!');
            writeln('====================================================');
            readkey;
          end
          else
          begin
            UbahNilaiAbsensi(data);
            gotoxy(1,1);writeln('============================================================================');
            gotoxy(29,2);writeln('REKAPITULASI ABSEN');
            gotoxy(1,3);writeln('----------------------------------------------------------------------------');
            writeln('NIM');
            gotoxy(12,4);writeln('Nama');
            gotoxy(40,4);writeln('1');
            gotoxy(43,4);writeln('2');
            gotoxy(46,4);writeln('3');
            gotoxy(49,4);writeln('4');
            gotoxy(52,4);writeln('5');
            gotoxy(55,4);writeln('6');
            gotoxy(58,4);writeln('7');
            gotoxy(61,4);writeln('8');
            gotoxy(64,4);writeln('9');
            gotoxy(67,4);writeln('10');
            gotoxy(71,4);writeln('Total');
            CetakAbsen(data);
          end;
        readkey;
        clrscr;
        end;
    //Keluar Program
    end;
  until menu=6;
  writeln('==========================================');
  writeln('Terimakasih Sudah Menggunakan Aplikasi Ini');
  writeln(' Mohon Maaf Jika Masih Ada Sedikit Bug... ');
  writeln('==========================================');
  writeln;
  write('Tekan Tombol Semabarang Untuk Keluar...');
readkey;
end.
