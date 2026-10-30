import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum UserRole {
  administrador('Administrador', 'Ana Torres', 'AT', Icons.shield_outlined),
  medico('Médico', 'Dr. Carlos Ruiz', 'CR', Icons.medical_services_outlined),
  recepcionista('Recepcionista', 'Lucía Gómez', 'LG', Icons.support_agent),
  farmacia('Farmacia', 'Pedro Salas', 'PS', Icons.medication_outlined),
  paciente('Paciente', 'María Fernández', 'MF', Icons.person_outline);

  const UserRole(this.label, this.userName, this.initials, this.icon);

  final String label;
  final String userName;
  final String initials;
  final IconData icon;
}

class Appointment {
  const Appointment({
    required this.time,
    required this.patient,
    required this.doctor,
    required this.specialty,
    required this.status,
    required this.room,
    this.initials = '',
  });

  final String time;
  final String patient;
  final String doctor;
  final String specialty;
  final String status;
  final String room;
  final String initials;
}

class WeekPoint {
  const WeekPoint(this.label, this.value);

  final String label;
  final int value;
}

class SpecialtyShare {
  const SpecialtyShare(this.label, this.value, this.color);

  final String label;
  final int value;
  final Color color;
}

class TimelineEvent {
  const TimelineEvent({
    required this.date,
    required this.title,
    required this.doctor,
    required this.description,
    required this.tags,
    this.icon = Icons.medical_information_outlined,
  });

  final String date;
  final String title;
  final String doctor;
  final String description;
  final List<String> tags;
  final IconData icon;
}

class Prescription {
  const Prescription({
    required this.id,
    required this.patient,
    required this.medication,
    required this.dose,
    required this.status,
    required this.date,
    required this.quantity,
  });

  final String id;
  final String patient;
  final String medication;
  final String dose;
  final String status;
  final String date;
  final String quantity;
}

class InventoryItem {
  const InventoryItem({
    required this.name,
    required this.presentation,
    required this.stock,
    required this.minimum,
  });

  final String name;
  final String presentation;
  final int stock;
  final int minimum;

  double get level => (stock / (minimum * 2.2)).clamp(0, 1).toDouble();
}

class PatientRow {
  const PatientRow({
    required this.name,
    required this.dni,
    required this.age,
    required this.phone,
    required this.lastVisit,
    required this.status,
    required this.initials,
  });

  final String name;
  final String dni;
  final int age;
  final String phone;
  final String lastVisit;
  final String status;
  final String initials;
}

class DoctorRow {
  const DoctorRow({
    required this.name,
    required this.specialty,
    required this.patients,
    required this.rating,
    required this.availability,
    required this.status,
    required this.initials,
    required this.color,
  });

  final String name;
  final String specialty;
  final int patients;
  final String rating;
  final String availability;
  final String status;
  final String initials;
  final Color color;
}

class PaymentRow {
  const PaymentRow({
    required this.id,
    required this.patient,
    required this.concept,
    required this.amount,
    required this.date,
    required this.method,
    required this.status,
  });

  final String id;
  final String patient;
  final String concept;
  final double amount;
  final String date;
  final String method;
  final String status;
}

class UserRow {
  const UserRow({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.lastAccess,
    required this.initials,
  });

  final String name;
  final String email;
  final String role;
  final String status;
  final String lastAccess;
  final String initials;
}

class MobileSpecialty {
  const MobileSpecialty({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.cost,
  });

  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String cost;
}

class MobileDoctor {
  const MobileDoctor({
    required this.name,
    required this.specialty,
    required this.experience,
    required this.rating,
    required this.initials,
    required this.color,
  });

  final String name;
  final String specialty;
  final String experience;
  final String rating;
  final String initials;
  final Color color;
}

class MobileConsultation {
  const MobileConsultation({
    required this.date,
    required this.doctor,
    required this.specialty,
    required this.diagnosis,
    required this.notes,
    required this.status,
  });

  final String date;
  final String doctor;
  final String specialty;
  final String diagnosis;
  final String notes;
  final String status;
}

abstract final class MockData {
  static const patientName = 'María Fernández';
  static const patientFirstName = 'María';
  static const patientInitials = 'MF';
  static const patientDni = '4587 ****';
  static const patientAge = 34;
  static const patientBlood = 'O+';
  static const patientPhone = '+51 987 654 321';
  static const patientEmail = 'maria.fernandez@correo.com';
  static const patientAddress = 'Av. Los Álamos 245, Lima';

  static const weekPoints = [
    WeekPoint('Lun', 18),
    WeekPoint('Mar', 24),
    WeekPoint('Mié', 21),
    WeekPoint('Jue', 28),
    WeekPoint('Vie', 32),
    WeekPoint('Sáb', 16),
    WeekPoint('Dom', 9),
  ];

  static const specialties = [
    SpecialtyShare('Medicina general', 32, AppColors.blue),
    SpecialtyShare('Pediatría', 24, AppColors.teal),
    SpecialtyShare('Cardiología', 18, AppColors.green),
    SpecialtyShare('Dermatología', 14, AppColors.amber),
    SpecialtyShare('Otros', 12, AppColors.muted),
  ];

  static const appointments = [
    Appointment(
      time: '08:30',
      patient: 'María Fernández',
      doctor: 'Dr. Carlos Ruiz',
      specialty: 'Medicina general',
      status: 'Confirmada',
      room: 'Consultorio 2',
      initials: 'MF',
    ),
    Appointment(
      time: '09:15',
      patient: 'José Ramírez',
      doctor: 'Dra. Elena Paredes',
      specialty: 'Cardiología',
      status: 'En espera',
      room: 'Consultorio 4',
      initials: 'JR',
    ),
    Appointment(
      time: '10:00',
      patient: 'Lucía Mendoza',
      doctor: 'Dr. Carlos Ruiz',
      specialty: 'Medicina general',
      status: 'Confirmada',
      room: 'Consultorio 2',
      initials: 'LM',
    ),
    Appointment(
      time: '10:45',
      patient: 'Diego Salazar',
      doctor: 'Dra. Sofía Vega',
      specialty: 'Pediatría',
      status: 'Pendiente',
      room: 'Consultorio 1',
      initials: 'DS',
    ),
    Appointment(
      time: '11:30',
      patient: 'Ana Castillo',
      doctor: 'Dr. Marco León',
      specialty: 'Dermatología',
      status: 'Cancelada',
      room: 'Consultorio 5',
      initials: 'AC',
    ),
    Appointment(
      time: '12:15',
      patient: 'Rosa Herrera',
      doctor: 'Dra. Elena Paredes',
      specialty: 'Cardiología',
      status: 'Confirmada',
      room: 'Consultorio 4',
      initials: 'RH',
    ),
  ];

  static const agendaSlots = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '15:00',
    '16:00',
  ];

  static const timeline = [
    TimelineEvent(
      date: '18 OCT 2026',
      title: 'Consulta de control',
      doctor: 'Dr. Carlos Ruiz · Medicina general',
      description: 'Paciente refiere mejoría del cuadro respiratorio. Se ajusta tratamiento y se solicita control en 15 días.',
      tags: ['Control', 'Vía aérea superior'],
      icon: Icons.medical_services_outlined,
    ),
    TimelineEvent(
      date: '02 OCT 2026',
      title: 'Diagnóstico: faringitis aguda',
      doctor: 'Dra. Elena Paredes · Medicina general',
      description: 'Se indica amoxicilina 500 mg cada 8 horas por 7 días y reposo. Evolución favorable.',
      tags: ['Diagnóstico', 'Receta emitida'],
      icon: Icons.coronavirus_outlined,
    ),
    TimelineEvent(
      date: '14 SEP 2026',
      title: 'Examen de laboratorio',
      doctor: 'Laboratorio central',
      description: 'Hemograma completo y perfil lipídico. Resultados dentro de los valores de referencia.',
      tags: ['Laboratorio', 'Resultados normales'],
      icon: Icons.science_outlined,
    ),
    TimelineEvent(
      date: '22 AGO 2026',
      title: 'Consulta preventiva',
      doctor: 'Dr. Carlos Ruiz · Medicina general',
      description: 'Chequeo anual. Se refuerzan recomendaciones de alimentación y actividad física.',
      tags: ['Preventiva', 'Chequeo anual'],
      icon: Icons.health_and_safety_outlined,
    ),
  ];

  static const prescriptions = [
    Prescription(
      id: 'RX-2041',
      patient: 'María Fernández',
      medication: 'Amoxicilina 500 mg',
      dose: '1 cápsula cada 8 horas · 7 días',
      status: 'En preparación',
      date: 'Hoy, 08:20',
      quantity: '21 cápsulas',
    ),
    Prescription(
      id: 'RX-2040',
      patient: 'José Ramírez',
      medication: 'Losartán 50 mg',
      dose: '1 tableta cada 12 horas · 30 días',
      status: 'Pendiente',
      date: 'Hoy, 08:05',
      quantity: '60 tabletas',
    ),
    Prescription(
      id: 'RX-2039',
      patient: 'Lucía Mendoza',
      medication: 'Ibuprofeno 400 mg',
      dose: '1 tableta cada 8 horas · 5 días',
      status: 'Entregada',
      date: 'Ayer, 17:40',
      quantity: '15 tabletas',
    ),
    Prescription(
      id: 'RX-2038',
      patient: 'Diego Salazar',
      medication: 'Jarabe pediátrico',
      dose: '5 ml cada 6 horas · 4 días',
      status: 'Sin stock',
      date: 'Ayer, 16:10',
      quantity: '1 frasco',
    ),
    Prescription(
      id: 'RX-2037',
      patient: 'Rosa Herrera',
      medication: 'Atorvastatina 20 mg',
      dose: '1 tableta por noche · 30 días',
      status: 'Entregada',
      date: 'Ayer, 15:25',
      quantity: '30 tabletas',
    ),
  ];

  static const inventory = [
    InventoryItem(
      name: 'Amoxicilina 500 mg',
      presentation: 'Cápsulas · caja x 100',
      stock: 8,
      minimum: 30,
    ),
    InventoryItem(
      name: 'Jarabe pediátrico',
      presentation: 'Frasco 120 ml',
      stock: 3,
      minimum: 15,
    ),
    InventoryItem(
      name: 'Losartán 50 mg',
      presentation: 'Tabletas · caja x 30',
      stock: 14,
      minimum: 25,
    ),
    InventoryItem(
      name: 'Ibuprofeno 400 mg',
      presentation: 'Tabletas · caja x 50',
      stock: 18,
      minimum: 20,
    ),
  ];

  static const patients = [
    PatientRow(
      name: 'María Fernández',
      dni: '4587 ****',
      age: 34,
      phone: '+51 987 654 321',
      lastVisit: '18 oct 2026',
      status: 'Activo',
      initials: 'MF',
    ),
    PatientRow(
      name: 'José Ramírez',
      dni: '3912 ****',
      age: 57,
      phone: '+51 912 345 678',
      lastVisit: '18 oct 2026',
      status: 'Activo',
      initials: 'JR',
    ),
    PatientRow(
      name: 'Lucía Mendoza',
      dni: '7045 ****',
      age: 29,
      phone: '+51 934 567 890',
      lastVisit: '15 oct 2026',
      status: 'En seguimiento',
      initials: 'LM',
    ),
    PatientRow(
      name: 'Diego Salazar',
      dni: '6123 ****',
      age: 8,
      phone: '+51 956 789 012',
      lastVisit: '12 oct 2026',
      status: 'Activo',
      initials: 'DS',
    ),
    PatientRow(
      name: 'Ana Castillo',
      dni: '5298 ****',
      age: 41,
      phone: '+51 978 901 234',
      lastVisit: '02 oct 2026',
      status: 'Inactivo',
      initials: 'AC',
    ),
    PatientRow(
      name: 'Rosa Herrera',
      dni: '4810 ****',
      age: 63,
      phone: '+51 901 234 567',
      lastVisit: '28 sep 2026',
      status: 'Activo',
      initials: 'RH',
    ),
  ];

  static const doctors = [
    DoctorRow(
      name: 'Dr. Carlos Ruiz',
      specialty: 'Medicina general',
      patients: 248,
      rating: '4.9',
      availability: 'Hoy · 14:00 - 18:00',
      status: 'Disponible',
      initials: 'CR',
      color: AppColors.blue,
    ),
    DoctorRow(
      name: 'Dra. Elena Paredes',
      specialty: 'Cardiología',
      patients: 186,
      rating: '4.8',
      availability: 'Hoy · 09:00 - 13:00',
      status: 'En consulta',
      initials: 'EP',
      color: AppColors.teal,
    ),
    DoctorRow(
      name: 'Dra. Sofía Vega',
      specialty: 'Pediatría',
      patients: 213,
      rating: '4.9',
      availability: 'Mañana · 08:00 - 12:00',
      status: 'Disponible',
      initials: 'SV',
      color: AppColors.green,
    ),
    DoctorRow(
      name: 'Dr. Marco León',
      specialty: 'Dermatología',
      patients: 142,
      rating: '4.7',
      availability: 'Vie · 10:00 - 16:00',
      status: 'Disponible',
      initials: 'ML',
      color: AppColors.amber,
    ),
    DoctorRow(
      name: 'Dra. Valeria Núñez',
      specialty: 'Ginecología',
      patients: 168,
      rating: '4.8',
      availability: 'Hoy · 15:00 - 19:00',
      status: 'En consulta',
      initials: 'VN',
      color: Color(0xFF7C3AED),
    ),
    DoctorRow(
      name: 'Dr. Andrés Ponce',
      specialty: 'Traumatología',
      patients: 121,
      rating: '4.6',
      availability: 'Sáb · 08:00 - 12:00',
      status: 'Descanso',
      initials: 'AP',
      color: AppColors.red,
    ),
  ];

  static const payments = [
    PaymentRow(
      id: 'PAG-8841',
      patient: 'María Fernández',
      concept: 'Consulta medicina general',
      amount: 80,
      date: 'Hoy, 08:32',
      method: 'Tarjeta',
      status: 'Pagado',
    ),
    PaymentRow(
      id: 'PAG-8840',
      patient: 'José Ramírez',
      concept: 'Consulta cardiología',
      amount: 150,
      date: 'Hoy, 09:20',
      method: 'Efectivo',
      status: 'Pagado',
    ),
    PaymentRow(
      id: 'PAG-8839',
      patient: 'Lucía Mendoza',
      concept: 'Perfil lipídico',
      amount: 120,
      date: 'Hoy, 10:05',
      method: 'Yape',
      status: 'Pendiente',
    ),
    PaymentRow(
      id: 'PAG-8838',
      patient: 'Diego Salazar',
      concept: 'Consulta pediatría',
      amount: 100,
      date: 'Ayer, 16:45',
      method: 'Tarjeta',
      status: 'Pagado',
    ),
    PaymentRow(
      id: 'PAG-8837',
      patient: 'Ana Castillo',
      concept: 'Consulta dermatología',
      amount: 130,
      date: 'Ayer, 11:30',
      method: 'Transferencia',
      status: 'Reembolsado',
    ),
  ];

  static const users = [
    UserRow(
      name: 'Ana Torres',
      email: 'ana.torres@medisalud.pe',
      role: 'Administrador',
      status: 'Activo',
      lastAccess: 'Hoy, 07:45',
      initials: 'AT',
    ),
    UserRow(
      name: 'Dr. Carlos Ruiz',
      email: 'carlos.ruiz@medisalud.pe',
      role: 'Médico',
      status: 'Activo',
      lastAccess: 'Hoy, 08:10',
      initials: 'CR',
    ),
    UserRow(
      name: 'Lucía Gómez',
      email: 'lucia.gomez@medisalud.pe',
      role: 'Recepcionista',
      status: 'Activo',
      lastAccess: 'Hoy, 07:30',
      initials: 'LG',
    ),
    UserRow(
      name: 'Pedro Salas',
      email: 'pedro.salas@medisalud.pe',
      role: 'Farmacia',
      status: 'Activo',
      lastAccess: 'Ayer, 18:05',
      initials: 'PS',
    ),
    UserRow(
      name: 'Dra. Elena Paredes',
      email: 'elena.paredes@medisalud.pe',
      role: 'Médico',
      status: 'Invitación pendiente',
      lastAccess: '—',
      initials: 'EP',
    ),
  ];

  static const mobileSpecialties = [
    MobileSpecialty(
      name: 'Medicina general',
      description: 'Atención integral y control',
      icon: Icons.medical_services_outlined,
      color: AppColors.blue,
      cost: 'S/ 80',
    ),
    MobileSpecialty(
      name: 'Pediatría',
      description: 'Salud para los más pequeños',
      icon: Icons.child_care_outlined,
      color: AppColors.teal,
      cost: 'S/ 100',
    ),
    MobileSpecialty(
      name: 'Cardiología',
      description: 'Cuidado del corazón',
      icon: Icons.favorite_border_rounded,
      color: AppColors.green,
      cost: 'S/ 150',
    ),
    MobileSpecialty(
      name: 'Dermatología',
      description: 'Cuidado de la piel',
      icon: Icons.spa_outlined,
      color: AppColors.amber,
      cost: 'S/ 130',
    ),
  ];

  static const mobileDoctors = [
    MobileDoctor(
      name: 'Dr. Carlos Ruiz',
      specialty: 'Medicina general',
      experience: '12 años de experiencia',
      rating: '4.9',
      initials: 'CR',
      color: AppColors.blue,
    ),
    MobileDoctor(
      name: 'Dra. Elena Paredes',
      specialty: 'Medicina general',
      experience: '9 años de experiencia',
      rating: '4.8',
      initials: 'EP',
      color: AppColors.teal,
    ),
    MobileDoctor(
      name: 'Dra. Sofía Vega',
      specialty: 'Medicina general',
      experience: '7 años de experiencia',
      rating: '4.9',
      initials: 'SV',
      color: AppColors.green,
    ),
  ];

  static const mobileDates = [
    ('Vie', '30', 'Oct'),
    ('Sáb', '31', 'Oct'),
    ('Lun', '02', 'Nov'),
    ('Mar', '03', 'Nov'),
  ];

  static const mobileTimes = [
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
  ];

  static const consultations = [
    MobileConsultation(
      date: '18 oct 2026',
      doctor: 'Dr. Carlos Ruiz',
      specialty: 'Medicina general',
      diagnosis: 'Control de vía aérea superior',
      notes: 'Mejoría del cuadro. Se ajusta tratamiento.',
      status: 'Atendida',
    ),
    MobileConsultation(
      date: '02 oct 2026',
      doctor: 'Dra. Elena Paredes',
      specialty: 'Medicina general',
      diagnosis: 'Faringitis aguda',
      notes: 'Tratamiento con amoxicilina por 7 días.',
      status: 'Atendida',
    ),
    MobileConsultation(
      date: '14 sep 2026',
      doctor: 'Laboratorio central',
      specialty: 'Laboratorio',
      diagnosis: 'Hemograma completo',
      notes: 'Resultados dentro de los valores normales.',
      status: 'Resultado listo',
    ),
  ];

  static const exams = [
    ('Hemograma completo', '14 sep 2026', 'Normal'),
    ('Perfil lipídico', '14 sep 2026', 'Normal'),
    ('Radiografía de tórax', '02 oct 2026', 'Normal'),
  ];

  static const medications = [
    ('Amoxicilina 500 mg', '1 cápsula cada 8 horas', '08:00', true),
    ('Ibuprofeno 400 mg', '1 tableta cada 8 horas', '14:00', false),
    ('Vitamina C', '1 tableta al día', '20:00', false),
  ];
}
