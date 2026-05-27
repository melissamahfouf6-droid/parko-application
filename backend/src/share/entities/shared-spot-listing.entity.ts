import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity('shared_spot_listings')
export class SharedSpotListing {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  sellerUserId!: string;

  @Column()
  lotId!: string;

  @Column()
  lotName!: string;

  @Column({ type: 'float' })
  lat!: number;

  @Column({ type: 'float' })
  lng!: number;

  /** Minutes of parking left when listed. */
  @Column({ type: 'int' })
  remainingMinutes!: number;

  /** Original session price (KWD). */
  @Column({ type: 'float' })
  originalPriceKwd!: number;

  /** Buyer pays this (20% off in spec). */
  @Column({ type: 'float' })
  salePriceKwd!: number;

  @Column({ default: 'active' })
  status!: string;

  @CreateDateColumn()
  createdAt!: Date;

  @Column({ type: 'datetime', nullable: true })
  expiresAt!: Date | null;
}
